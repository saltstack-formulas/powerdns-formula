# -*- coding: utf-8 -*-
'''
Module to provide access to the power DNS http API

:configuration: This module uses the pdnaspi python library
    parameters as well as configuration settings::

        pdns.url: "http://192.168.10.65:8081"
        pdns.server_id: "localhost"
        pdns.api_key: "f5d2abcd"

    This data can also be passed into pillar. Options passed into opts will
    overwrite options passed into pillar.
'''
from __future__ import absolute_import

# Import python libs
import logging
from distutils.version import LooseVersion  # pylint: disable=import-error,no-name-in-module
import json
import re
from pprint import pformat

# Import salt libs
from salt.ext.six import string_types
from salt.exceptions import get_error_message as _get_error_message


# Import third party libs
try:
    import pdnsapi as api
    from pdnsapi.exceptions import (
        PDNSAccessDeniedException, PDNSNotFoundException,
        PDNSProtocolViolationException, PDNSServerErrorException,
        PDNSException)

    HAS_PDNSAPI = True
except ImportError:
    HAS_PDNSAPI = False

log = logging.getLogger(__name__)


def __virtual__():
    '''
    Only load this module if pdnsapi is installed
    '''
    if HAS_PDNSAPI:
        return 'powerdns'
    else:
        return (False, 'The powerdns execution module cannot be loaded: the pdnsapi library is not available.')

def _canonicalize_name(name):
    if not name.endswith('.'):
        return name + '.'
    else:
        return name


def _connect():
    url = __salt__['config.option']('pdns.url')
    server_id = __salt__['config.option']('pdns.server_id')
    api_key = __salt__['config.option']('pdns.api_key')

    log.error("Attempting to connect: '%s' '%s' '%s'" % (url, server_id, api_key))

    try:
        conn = api.init_api(url, server_id, api_key)

    except PDNSException as e:
        log.error("Exception while opening API connection: '%s'" % (e))
        return False

    log.error("connected: '%s' '%s' '%s'" % (url, server_id, api_key))
    return conn

def list_zones():
    conn = _connect()

    if not conn:
        return "Failed to connect to powerDNS"

    log.error("Attempting to pull zonelist")
    zonelist = conn.zones
    log.error("Zonelist: %s" % (zonelist))

    return [zone.name for zone in zonelist]

def get_zone(name):
    conn = _connect()

    if not conn:
        return "Failed to connect to powerDNS"

    try:
        zone = conn.get_zone(name)
    except PDNSException as e:
        return "Exception while getting zone: '%s'" % (e)

    
    return [{'name': record.name, 'type': record.type, 'ttl': record.ttl, 'records': [record2 for record2 in record.records]} for record in zone.records]

def get_record(zone, name, rtype):
    conn = _connect()

    if not conn:
        return "Failed to connect to powerDNS"

    canonical_zone = _canonicalize_name(zone)

    try:
        zone_rec = conn.get_zone(canonical_zone)
    except PDNSException as e:
        return "Could not get zone '%s': '%s'" % (canonical_zone, e)

    if not name.endswith(zone):
        name = name + '.' + zone
    try:
        record = zone_rec.get_record(_canonicalize_name(name), rtype)
    except PDNSNotFoundException as e:
        return "Record '%s' not found." % (name)

    return { 'zone': canonical_zone, 'name': record.name, 'type': record.type, 'ttl': record.ttl, 'records': [rec for rec in record.records]}

def add_record(zone, name, rtype, ttl=300, **kwargs):
    conn = _connect()

    if not conn:
        return "Failed to connect to powerDNS"

    if 'records' not in kwargs:
        return "Must specify records.  Ex: records='[ list, of, records ]'"

    canonical_zone = _canonicalize_name(zone)

    try:
        zone_rec = conn.get_zone(canonical_zone)
    except PDNSException as e:
        return "Could not get zone '%s': '%s'" % (canonical_zone, e)

    if not name.endswith(zone):
        name = name + '.' + zone

    record = api.Record(_canonicalize_name(name), rtype, kwargs['records'], ttl)

    try:
        foo = zone_rec.add_record(record)
    except PDNSException as e:
        return "add_record failed: '%s'" % (e)

    return True

#    return { 'zone': canonical_zone, 'name': record.name, 'type': record.type, 'ttl': record.ttl, 'records': [rec for rec in record.records]}

def argtest(*args, **kwargs):
    #log.error("'%s'" % (pformat(kwargs)))

    kwargs['args'] = args
    return kwargs

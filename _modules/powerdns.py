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

# Import salt libs
from salt.ext.six import string_types
from salt.exceptions import get_error_message as _get_error_message


# Import third party libs
try:
    import pdnsapi as api
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

def _connect():
    url = __salt__['config.option']('pdns.url')
    server_id = __salt__['config.option']('pdns.server_id')
    api_key = __salt__['config.option']('pdns.api_key')

    log.error("Attempting to connect: '%s' '%s' '%s'" % (url, server_id, api_key))

    try:
        conn = api.init_api(url, server_id, api_key)

    except Exception as e:
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


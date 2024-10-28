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

try:
    from requests import HTTPError, Request
    from requests_toolbelt import sessions
    HAS_REQUESTS = True
except ImportError:
    HAS_REQUESTS = False

import logging
log = logging.getLogger(__name__)

from simplejson.errors import JSONDecodeError

def __virtual__():
  '''
  Only load this module if requests is installed
  '''
  if HAS_REQUESTS:
    return 'powerdns'
  else:
    return (False, 'The powerdns execution module cannot be loaded: the requests and/or requests_toolbelt libraries are not available.')

def _init():
  url = __salt__['config.option']('pdns.url')
  server_id = __salt__['config.option']('pdns.server_id')
  api_key = __salt__['config.option']('pdns.api_key')

  session = sessions.BaseUrlSession(base_url=f'{url}/api/v1/servers/{server_id}/')
  session.headers = {
    'Accept': 'application/json',
    'X-API-Key': str(api_key),
  }

  log.debug(session.base_url)
  log.debug(session.headers)

  get_root(session)

  return session

def new_session(is_state_module):
  if is_state_module:
    return _init()

def get_root(session=None):
  log.debug('Requesting root')
  if session is None:
    session = _init()
  log.debug(session.base_url)
  test_request = Request(method='GET', url=session.base_url.rstrip('/'))
  log.debug(test_request.url)
  test_request = session.prepare_request(test_request)
  try:
    session.send(test_request).raise_for_status()
  except HTTPError as e:
    log.debug(f'Exception while connecting to the PowerDNS API: {e}')
    return False

def _session_get(session, path, raw=False):
  response = session.get(path).json()

  if raw:
    return response, None

  if isinstance(response, list) or isinstance(response, dict) and not 'error' in response:
    return response, True

  elif isinstance(response, dict) and 'error' in response:
    return response['error'], False

  return None, False

def get_zones(session=None):
  log.debug('Requesting zones')
  if session is None:
    session = _init()
  body, result = _session_get(session, 'zones')
  if not result:
    return f'Failed to query zones: {body}'
  log.debug("Zonelist: %s" % (body))

  return [zone['name'] for zone in body]

def get_zone(name, session=None):
  log.debug(f'Requesting zone "{name}"')
  if session is None:
    session = _init()
  body, result = _session_get(session, f'zones/{name}')
  if not result:
    return f'Failed to query zone: {body}'

  return body

def get_zone_rrsets(name, raw=False, session=None):
  log.debug(f'Requesting zone "{name}" records')
  zone = get_zone(name, session)

  if isinstance(zone, dict):
    rrsets = zone.get('rrsets', [])
    if raw:
      return rrsets

    return [
      {
        'name': rrset.get('name'),
        'records': rrset.get('records', []),
        'ttl': rrset.get('ttl'),
        'type': rrset.get('type'),
      } for rrset in rrsets
    ]

  return zone

def get_zone_exists(name, session=None):
  if session is None:
    session = _init()
  response, _ = _session_get(session, f'zones/{name}', raw=True)
  if isinstance(response, dict):
    if 'error' in response:
      error = response['error']
      if error == 'Not Found':
        return False
      else:
        return f'Failed to query zone: {error}'

    # just checking a couple arbitrary attributes to make sure it's actually a zone object
    elif 'id' in response and 'url' in response:
      return True

  return None

def get_records(zone, recname, rectype=None, session=None):
  log.debug(f'Requesting zone "{zone}" record "{recname}"')
  if session is None:
    session = _init()

  recname = canonicalize_recname(zone, recname)
  rrsets = get_zone_rrsets(zone, raw=False, session=session)

  log.debug(rrsets)

  records = []

  if not isinstance(rrsets, list):
    return rrsets

  for rrset in rrsets:
    if rrset['name'] == recname and ( rrset['type'] == rectype and rectype is not None ):
      records.append(rrset)

  return records

def canonicalize_name(name):
  if not name.endswith('.'):
    name = f'{name}.'

  return name

def canonicalize_recname(zone, recname):
  canonzone = canonicalize_name(zone)
  if recname == '.':
    return canonzone

  if recname.endswith('.') or recname.endswith(canonzone):
    return recname

  #if zone in recname:
  #  return canonzone

  if recname.endswith(zone):
    name = recname

  else:
    name = f'{recname}.{zone}'

  return canonicalize_name(name)

def _handle_result(result, expect):
  status = result.status_code
  log.debug(f'{status} {result.text}')

  try:
    output = result.json()
  except JSONDecodeError:
    output = result.text

  if isinstance(output, dict) and 'error' in output:
    output = output['error']

  if status == expect:
    return True, status, output

  return False, status, output

def post_zone(zone, payload, session=None):
  if session is None:
    session = _init()

  if get_zone_exists(zone):
    return False, f'Failed to post: zone "{zone}" already exists', None

  log.debug(payload)

  result = session.post(f'zones', json=payload)

  return _handle_result(result, 201)

def patch_zone(zone, payload, session=None):
  if session is None:
    session = _init()

  if not get_zone_exists(zone):
    return False, f'Failed to patch: zone "{zone}" does not exist', None

  log.debug(payload)

  result = session.patch(f'zones/{zone}', json=payload)
  
  return _handle_result(result, 204)

def patch_rrsets(zone, changetype, session, recname=None, rectype=None, record=None, recttl=None, rrsets=None):
  payload = {}

  if rrsets:
    payload['rrsets'] = rrsets
    for i, _ in enumerate(payload['rrsets']):
      payload['rrsets'][i]['changetype'] = changetype

  else:
    payload['rrsets'] = [
      {
        'name': canonicalize_recname(zone, recname),
        'changetype': changetype,
        'type': rectype,
      }
    ]

  if changetype == 'REPLACE' and not rrsets:
    payload['rrsets'][0].update(
      {
        'records': [
          {
            'content': record,
          }
        ],
        'ttl': recttl,
      }
    )

  return patch_zone(zone, payload, session)

def create_record(zone, recname, recttl, rectype, record, session=None):
  return patch_rrsets(zone, recname=recname, rectype=rectype, changetype='REPLACE', session=session, record=record, recttl=recttl)

def delete_record(zone, recname, rectype, session=None):
  return patch_rrsets(zone, recname=recname, rectype=rectype, changetype='DELETE', session=session)



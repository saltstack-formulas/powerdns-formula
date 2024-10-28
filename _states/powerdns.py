__virtualname__ = 'powerdns'

def __virtual__():
    if 'powerdns.get_zone' in __salt__:
        return __virtualname__
    return False

from copy import deepcopy
from dictdiffer import diff as dictdiff
import logging
log = logging.getLogger(__name__)


def zone_present(name, kind=None, rrsets=None, masters=None, dnssec=None, nsec3param=None, nsec3narrow=None, presigned=None, soa_edit=None, soa_edit_api=None, api_rectify=None, catalog=None, nameservers=None, master_tsig_key_ids=None, slave_tsig_key_ids=None):

  want_data = {
    key: value
    for key, value in locals().items()
    if value is not None
  }

  zone = __salt__['powerdns.canonicalize_name'](name)
  want_data['name'] = zone

  if 'kind' in want_data:
    want_data['kind'] = want_data['kind'].capitalize()

  ret = {'name': zone, 'changes': {'old': {}, 'new': {}}, 'result': False, 'comment': ''}

  session = __salt__['powerdns.new_session'](True)
  log.debug('powerdns: got session')
  
  exists = __salt__['powerdns.get_zone_exists'](zone, session)

  log.debug(f'powerdns: zone exists => {exists}')
  log.debug(f'powerdns: want data => {want_data}')

  if exists:
    have_data = __salt__['powerdns.get_zone'](zone, session)
    log.debug(f'powerdns: have data => {have_data}')
    payload = have_data.copy()

    for have_key, have_value in have_data.items():
      log.debug(f'powerdns: reading have key {have_key}')

      if have_key in want_data:
        want_value = want_data[have_key]
        log.debug(f'powerdns: key {have_key} is wanted with value {want_value}')

        payload.update(
          {
            have_key: deepcopy(want_value)
          }
        )

        if isinstance(have_value, str) or isinstance(have_value, int):
          if have_value == want_value:
            log.debug(f'powerdns: str/int {have_value} already matches')

          else:
            ret['changes']['old'][have_key] = have_value
            ret['changes']['new'][have_key] = want_value

        elif isinstance(have_value, list):  # rrset/nameserver list?
          if have_key == 'nameserver':
            have_value = have_value.sort()
            want_value = want_value.sort()

            if have_value == want_value:
              log.debug(f'powerdns: list {have_value} already matches')

            else:
              # maybe make a diff of the lists here
              ret['changes']['old'][have_key] = have_value
              ret['changes']['new'][have_key] = want_value

          elif have_key == 'rrsets':
            processed_rrsets = []
            processed_wanted_rrsets = []

            # 1. preprocess rrsets
            for i_rrs, rrset in enumerate(want_value):
              rrset_name = __salt__['powerdns.canonicalize_recname'](zone, rrset['name'])
              for i_rec, record in enumerate(rrset.get('records', [])):
                if 'disabled' not in record:
                  payload[have_key][i_rrs]['records'][i_rec]['disabled'] = False
              if '.' not in rrset['name']:
                payload[have_key][i_rrs]['name'] = rrset_name
              if not rrset.get('comments', []):
                payload[have_key][i_rrs]['comments'] = []

            # 2. process changes to existing rrsets
            for have_rrset in have_value:
              processed_rrsets.append((have_rrset['name'], have_rrset['type']))

              for i, want_rrset in enumerate(payload[have_key]):
                if have_rrset['name'] == want_rrset['name'] and have_rrset['type'] == want_rrset['type']:
                  log.debug(f'powerdns: want_rrset {want_rrset}')
                  log.debug('comparing')
                  log.debug(have_rrset)
                  log.debug(want_rrset)
                  diff = list(dictdiff(have_rrset, want_rrset))
                  log.debug(f'powerdns: have diff')
                  for x in diff:
                    log.debug(x)

                  if diff:
                    if not 'rrset_diffs' in ret['changes']:
                      ret['changes']['rrset_diffs'] = {}

                    if not name in ret['changes']['rrset_diffs']:
                      ret['changes']['rrset_diffs'][name] = []

                    ret['changes']['rrset_diffs'][name].append(diff)

                  else:
                    payload[have_key].pop(i)

                  wrrsettup = (want_rrset['name'], want_rrset['type'])
                  processed_rrsets.remove(wrrsettup)
                  processed_wanted_rrsets.append(wrrsettup)

                  break

            # 3. process new rrsets
            for want_rrset in payload[have_key]:
              for wrrsettup in processed_wanted_rrsets:
                if want_rrset['name'] == wrrsettup[0] and want_rrset['type'] == wrrsettup[1]:
                  break

              else:
                if not 'rrset_additions' in ret['changes']:
                  ret['changes']['rrset_additions'] = []

                ret['changes']['rrset_additions'].append(rrset)

            # 4. process rrset removals
            for rrset in processed_rrsets:
              if rrset[1] == 'SOA':
                continue

              payload[have_key].append(
                {
                  'name': rrset[0],
                  'type': rrset[1],
                  'changetype': 'DELETE',
                }
              )

              if not 'rrset_deletions' in ret['changes']:
                ret['changes']['rrset_deletions'] = []

              ret['changes']['rrset_deletions'].append(rrset)

    if 'rrset_diffs' in ret['changes']:
      for i, rrset in enumerate(payload['rrsets']):
        payload['rrsets'][i]['changetype'] = 'REPLACE'

    log.debug(f'powerdns: payload: {payload}')

    for x in ['old', 'new']:
      if not ret['changes'][x]:
        del ret['changes'][x]

    if not ret['changes']:
      ret['result'] = True
      ret['comment'] = 'Zone is already in the correct state.'
      return ret

    if ret['changes']:
      if __opts__['test']:
        ret['result'] = None
        ret['comment'] = 'Zone would be modified.'
        return ret

    if not 'rrsets' in payload:
      payload['rrsets'] = []

    ok, status, output = __salt__['powerdns.patch_zone'](zone, payload, session)

    if ok:
      ret['result'] = True
      ret['comment'] = f'Zone modified: {status} - {output}'

    else:
      ret['result'] = False
      ret['comment'] = f'Zone modification failed: {status} - {output}'

    return ret

  else:  # zone does not exist
    ret['changes'] = {
      'new': want_data,
      'old': {},
    }

    if __opts__['test']:
      ret['result'] = None
      ret['comment'] = 'Zone would be created.'
      return ret

    ok, status, output = __salt__['powerdns.post_zone'](zone, payload, session)

    if ok:
      ret['result'] = True
      ret['comment'] = f'Zone created: {status} - {output}'

    else:
      ret['result'] = False
      ret['comment'] = f'Zone creation failed: {status} - {output}'

    return ret

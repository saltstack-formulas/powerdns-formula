# -*- coding: utf-8 -*-
'''
'''

# Define the module's virtual name
__virtualname__ = 'powerdns'


def __virtual__():
    if 'powerdns.get_zone' in __salt__:
        return __virtualname__
    return False

def test(name, *args, **kwargs):
    zzz = __salt__['powerdns.argtest'](args, **kwargs)
    ret = {'name': name,
           'changes': {},
           'result': zzz,
           'comment': ''}

    return ret

def zone_present(name, name_servers=None, records=None):
    ret = {'name': name,
           'changes': {},
           'result': False,
           'comment': ''}

    if __salt__['powerdns.zone_exists'](name):
        ret['result'] = True
        ret['comment'] = 'Zone already present.'
        return ret

    zone = __salt__['powerdns.add_zone'](name, name_servers, records)
    if type(zone) is list:
        ret['result'] = True
        ret['comment'] = 'Zone present.'
        ret['changes'] = { name : { 'old': '', 'new': zone } }
        
    return ret

def zone_absent(name):
    ret = {'name': name,
           'changes': {},
           'result': False,
           'comment': ''}

    if not __salt__['powerdns.zone_exists'](name):
        ret['result'] = True
        ret['comment'] = 'Zone already absent.'
        return ret
    else:
        zone = __salt__['powerdns.get_zone'](name)

    if __salt__['powerdns.del_zone'](name):
        ret['result'] = True
        ret['comment'] = 'Zone absent.'
        ret['changes'] = { name : { 'old': zone, 'new': '' } }
        
    return ret

def record_present(zone, name, record_type, ttl=300, records=[]):
    ret = {'name': name,
           'changes': {},
           'result': False,
           'comment': ''}
    old_record = __salt__['powerdns.get_record'](zone, name, record_type)
    if __salt__['powerdns.add_record'](zone, name, record_type, ttl, records=records):
        ret['result'] = True
        ret['comment'] = "Record present"
        new_record = __salt__['powerdns.get_record'](zone, name, record_type)
        if new_record == old_record:
            ret['changes'] = {}
        else:    
            ret['changes'] = { name : { 'new': { 'zone': zone, 'name': name, 'type': record_type, 'ttl': ttl, 'records': records }, 'old': old_record } }
    
    return ret

select p.code privilege, 
       t.name, 
       t.description, 
       perm.code code, 
       perm.resource_type_name, 
       perm.action
from  fusion.ASE_PRIVILEGE_B p, 
      fusion.ASE_PERMISSION_B perm, 
      fusion.ASE_PRIVILEGE_TL t
where p.privilege_id = perm.privilege_id
and p.PRIVILEGE_ID=t.PRIVILEGE_ID 
and t.language='US'
and sysdate between p.effective_start_date and nvl(p.effective_end_date, sysdate)
and sysdate between perm.effective_start_date 
and nvl(perm.effective_end_date, sysdate)
and perm.resource_type_name='ESSMetadataResourceType'
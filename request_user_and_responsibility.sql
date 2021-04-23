SELECT fu.USER_NAME,
  frt.responsibility_name,
  frg.request_group_name,
  frgu.request_unit_type,
  DECODE (frgu.request_unit_type,
  'A' ,'Application',
  'P' ,'Program',
  'S' ,'Request Set',
  'Unknown')Request_type,
  fcpt.user_concurrent_program_name
FROM apps.fnd_Responsibility fr,
  apps.fnd_responsibility_tl frt,
  apps.fnd_request_groups frg,
  apps.fnd_request_group_units frgu,
  apps.fnd_concurrent_programs_tl fcpt,
  apps.fnd_user_resp_groups_direct furg,
  apps.fnd_user fu
WHERE frt.responsibility_id= fr.responsibility_id
AND frg.request_group_id= fr.request_group_id
AND furg.RESPONSIBILITY_ID= fr.RESPONSIBILITY_ID
AND furg.USER_ID    = fu.USER_ID
AND frgu.request_group_id = frg.request_group_id
AND fcpt.concurrent_program_id        = frgu.request_unit_id
AND fcpt.user_concurrent_program_name = NVL(:p_conc_prog_name,fcpt.user_concurrent_program_name)
AND frt.responsibility_name = NVL(:p_resp_name,frt.responsibility_name)
AND fu.USER_NAME=nvl(:p_user_name , fu.USER_NAME)
ORDER BY 1,2,3;
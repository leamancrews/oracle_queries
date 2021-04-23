SELECT a.USERNAME,
  c.ROLE_COMMON_NAME, 
  c.ROLE_DISTINGUISHED_NAME
FROM PER_USERS a, 
  PER_USER_ROLES b,
PER_ROLES_DN_VL c
WHERE a.USER_ID = b.USER_ID 
AND b.ROLE_ID = c.ROLE_ID 
AND a.USERNAME IN ('dvelasquez', 'asanders', 'awiddifield')
SELECT   SUBSTR (a.owner, 1, 20), SUBSTR (a.NAME, 1, 30),
         SUBSTR (a.TYPE, 1, 20), SUBSTR (u.status, 1, 10) stat,
         u.last_ddl_time, SUBSTR (text, 1, 80) description
    FROM dba_source a, dba_objects u
   WHERE 2 = 2 AND u.object_name = a.NAME
--and a.text like â%Header%â
         AND a.TYPE = u.object_type
--and a.name like âPA_%API%â
ORDER BY a.owner, a.NAME;
select s.sid, s.serial#, to_char(logon_time,’mm/dd hh24:mi:ss’) lt,
s.username, s.osuser, p.spid, nvl(s.program, s.module) program,
s.last_call_et/60 et,
decode(s.event,’SQL*Net message from dblink’,’DbLink’,
‘PL/SQL lock timer’,’PL Tmr’,
‘enq: TX – contention’,’TXLock’,
‘enq: DX – contention’,’DXLock’,
‘enq: TX – row lock contention’,’TXLock’,
‘direct path write’,’DP Wr’,
‘direct path read’,’DP Rd’,
‘latch: cache buffers chains’,’CB Chn’,
‘db file scattered read’, ‘FTS’,
‘db file sequential read’, ‘Idx Rd’,
‘buffer busy waits’,’BB Wts’) evt,
nvl(s.action,s.machine) action,
p.pga_used_mem/1024/1024 pm
from v$session s, v$process p
where s.status = ‘ACTIVE’
and s.username is not null
and s.paddr = p.addr
and s.action !=’Service Management’
and s.last_call_et > 3600
order by logon_time
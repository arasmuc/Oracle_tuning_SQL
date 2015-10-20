-- %D%
-- %D%  sql_waits.sql  - List Database Session Waits 
-- %D%  information about wait events for which active sessions are currently waiting
-- %D%  example:  @sql_waits.sql
-- %D%  author: Arkadiusz Karol Borucki
-- %D%  date: 08.10.2015
-- %D%  query against V$SESSION and V$SESSION_WAIT
-- %D%  version 1.00

set lines 150
prompt 
prompt
prompt ************************************************************************
prompt *********     Top 30 database waits (kumulativ)  
prompt ************************************************************************

SET pages 3000
SET lines  1200
SET trimspool ON
SET trimout   ON


column ev   heading 'Event' format 99999999D9
column proc heading '% Total' format 9999999D99
column un   heading 'User name' format 999999
column wcid heading 'Wait Class ID' format 99999D99
column wc   heading 'Wait Class' format 999999D99
column wt   heading 'Wait Time' format 99999D99
column pr   heading 'DRead/Exec' format 9999999D9
column sw   heading 'Sec/Wait' format 9999999999
column sid   heading 'SID' format 9999999999
column sr   heading 'Serial' format 9999999999
column fn   heading 'File ' format 9999999999
column bn   heading 'Block number' format 9999999999



select * from
(select a.event as "ev",b.username as "un",b.sid as "sid", b.SERIAL# as "sr", a.seconds_in_wait as "sw", a.p1 as "fn", a.p2 as "bn",
a.seconds_in_wait*100/(select sum(a.seconds_in_wait)  from 
v$session_wait a 
left join v$session b on a.sid=b.sid where 
a.event not in (
'dispatcher timer',
'lock element cleanup',
'Null event',
'parallel query dequeue wait',
'parallel query idle wait - Slaves',
'parallel query idle wait - Slaves',
'pipe get',
'PL/SQL lock timer',
'pmon timer',
'rdbms ipc message',
'slave wait',
'smon timer',
'SQL*Net break/reset to client',
'SQL*Net message from client',
'SQL*Net message to client',
'SQL*Net more data to client',
'virtual circuit status',
'WMON goes to sleep'
) 
and a.event not like '%idle%'
and a.event not like '%done%'
and a.seconds_in_wait > 0 ) as "proc",a.wait_time as "wt", 
a.wait_class as "wc"
from 
v$session_wait a 
left join v$session b on a.sid=b.sid where 
a.event not in (
'dispatcher timer',
'lock element cleanup',
'Null event',
'parallel query dequeue wait',
'parallel query idle wait - Slaves',
'parallel query idle wait - Slaves',
'pipe get',
'PL/SQL lock timer',
'pmon timer',
'rdbms ipc message',
'slave wait',
'smon timer',
'SQL*Net break/reset to client',
'SQL*Net message from client',
'SQL*Net message to client',
'SQL*Net more data to client',
'virtual circuit status',
'WMON goes to sleep'
) 
and a.event not like '%idle%'
and a.event not like '%done%'
and a.seconds_in_wait > 0 
order by a.seconds_in_wait desc)
where rownum < 31;




select event, state, count(*) from v$session_wait group by event, state order by 3 desc;
























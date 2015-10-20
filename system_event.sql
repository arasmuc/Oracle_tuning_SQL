-- %D%
-- %D%  system_event.sql  - shows current events within Oracle instance
-- %D%  example:  @system_event.sql
-- %D%  author: Arkadiusz Karol Borucki
-- %D%  date: 12.10.2015
-- %D%  query against V$SYSTEM_EVENT
-- %D%  version 1.00
-- %D%
 
SET pages 3000
SET lines  1200

prompt ************************************************************************
prompt ********         Current wait events within Oracle instance 
prompt ************************************************************************


column ev   heading 'Event' format 99999999D9
column tw   heading 'Total|Waits' format 999999999
column tiw  heading 'Time|Waited' format 999999999
column to   heading 'Total Timeouts' format 99999999999
column aw   heading 'Average Waits' format 9999999999
column wt   heading 'Wait Time' format 99999D99
column wc   heading 'Wait Class' format 9999999D9 
column pro  heading 'Total %' format 999999D999 
 
select * from (
select event as "ev", total_waits as "tw", time_waited as "tiw", total_timeouts as "to", 
average_wait as "aw", total_waits*100/(select sum(total_waits) from v$system_event where
event not in (
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
and event not like '%Idle%'
and event not like '%done%') as "pro",
wait_class as "wc"
from v$system_event where
event not in (
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
and event not like '%idle%'
and event not like '%done%'
order by total_waits desc)
where ROWNUM < 31;
 
 
 

   




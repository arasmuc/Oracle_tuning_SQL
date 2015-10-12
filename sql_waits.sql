-- %D%
-- %D%  sql_waits.sql  - shows top sql waits
-- %D%  example:  @sql_exec.sql
-- %D%  author: Arkadiusz Karol Borucki
-- %D%  date: 08.10.2015
-- %D%

set lines 150
prompt 
prompt
prompt ************************************************************************
prompt *********     Top 20 Sql waits (kumulativ) Statements, ausser SYS,SYSTEM, 
prompt ************************************************************************

SET pages 3000
SET lines  1200
SET trimspool ON
SET trimout   ON




select event, wait_class_id, wait_class, wait_time, seconds_in_wait from v$session_wait order by seconds_in_wait desc;

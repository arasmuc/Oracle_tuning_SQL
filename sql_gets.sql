-- %D%
-- %D%  sql_gets.sql  - shows top sql queries / execution plan ordered by buffer gets
-- %D%  example:  @sql_gets.sql
-- %D%  author: Arkadiusz Karol Borucki
-- %D%  date: 08.10.2015
-- %D%  query against V$SQL and DBA_USERS
-- %D%
-- %D%

set lines 150
prompt 
prompt 
prompt
prompt ************************************************************************
prompt *** Top 20 Buffer gets (kumulativ) Statements, ausser SYS,SYSTEM, 
prompt ************************************************************************

SET pages 3000
SET lines  1200
SET trimspool ON
SET trimout   ON


column bg   heading 'Buffer Gets' format 999999999
column proc heading '% Total' format 9999999D99
column dr   heading 'Disc Reads' format 999999999
column et   heading 'Elapse Time' format 99999999D9
column ex   heading 'Executions' format 9999999999
column etpe heading 'Elapsed/Exec' format 99999D99
column cis  heading 'CPU' format 999999D99
column cpe  heading 'CPU/Exec' format 99999D99
column pr   heading 'DRead/Exec' format 9999999D9
column si   heading 'Sql Id' format 9999999999
column un   heading 'User name' format 999999
column oc   heading 'Optimazer Cost' format 9999999999
column cn   heading 'Child number' format 9999999999


select * from (
select a.buffer_gets as "bg",
buffer_gets*100/(select sum(buffer_gets) from 
v$sql a left join
dba_users b on a.parsing_schema_id = b.user_id where executions>0 and a.parsing_schema_id not in (0,5)) as proc,
a.disk_reads as dr,a.executions as ex,
a.elapsed_time/1000000 as et,
a.cpu_time/1000000 as "cis", 
elapsed_time/executions/1000000  as "etpe",
a.cpu_time/executions/1000000 as cpe,
a.disk_reads/executions as "pr", 
a.sql_id as si, b.username as un, 
a.optimizer_cost as oc, 
a.child_number as cn
from
v$sql a left join
dba_users b on a.parsing_schema_id = b.user_id where executions>0 and a.parsing_schema_id not in (0,5)
order by a.buffer_gets desc) 
where ROWNUM < 21;

prompt 
prompt *****************************************************************************
prompt **********        ERSTE Execution Plan - user not SYS, SYSTEM, DBSNMP, NAGIOS
prompt *****************************************************************************


select 
plan_table_output from v$sql s, 
table(dbms_xplan.display_cursor(s.sql_id, s.child_number, 'TYPICAL')) t
where  
s.sql_id =(select distinct sql_id from v$sql where SQL_ID = (select sql_id from (select sql_fulltext, 
sql_id from v$sql
where parsing_schema_id not in (0,5) 
and optimizer_cost IS NOT NULL
order by buffer_gets desc) 
where rownum < 2));


prompt ******************************************************************************
prompt **********        ZWEITE Execution Plan - user not SYS, SYSTEM, DBSNMP, NAGIOS
prompt ******************************************************************************


select plan_table_output from v$sql s, table(dbms_xplan.display_cursor(s.sql_id, s.child_number, 'TYPICAL')) t
where  
s.sql_id =(select distinct sql_id from v$sql where SQL_ID = (select sql_id from (select sql_id, row_number() over (order by buffer_gets desc) r from v$sql
where parsing_schema_id not in (0,5) and optimizer_cost IS NOT NULL
) 
where r = 2));


prompt ******************************************************************************
prompt **********        DRITTE Execution Plan - user not SYS, SYSTEM, DBSNMP, NAGIOS
prompt ******************************************************************************


select plan_table_output from v$sql s, table(dbms_xplan.display_cursor(s.sql_id, s.child_number, 'TYPICAL')) t
where  
s.sql_id =(select distinct sql_id from v$sql where SQL_ID = (select sql_id from (select sql_id, row_number() over (order by buffer_gets desc) r from v$sql
where parsing_schema_id not in (0,5) and optimizer_cost IS NOT NULL
) 
where r = 3));







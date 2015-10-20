-- %D%
-- %D%  sql_exec.sql  - shows top sql queries most offten executed
-- %D%  example:  @sql_exec.sql
-- %D%  author: Arkadiusz Karol Borucki
-- %D%  date: 08.10.2015
-- %D%  query against V$SQL and DBA_USERS
-- %D%  version 1.00


prompt 
prompt
prompt ************************************************************************
prompt *** Top 20 Executed queries (kumulativ) Statements, except SYS,SYSTEM, 
prompt ************************************************************************

SET pages 3000
SET lines  1200
SET trimspool ON
SET trimout   ON


column bg   heading 'Buffer Gets' format 999999999
column proc heading '% Total' format 999999D999
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
select a.executions as ex, 
executions*100/(select sum(executions) from v$sql a left join
dba_users b on a.parsing_schema_id = b.user_id where executions>0 and a.parsing_schema_id not in (0,5)) as proc, 
a.buffer_gets as "bg",a.disk_reads as dr,
a.elapsed_time/1000000 as et,
a.cpu_time/1000000 as "cis", 
elapsed_time/executions/1000000  as "etpe",
a.cpu_time/executions/1000000 as cpe,
a.disk_reads/executions as "pr", 
a.sql_id as si, 
b.username as un, 
a.optimizer_cost as oc, 
a.child_number as cn
from
v$sql a left join
dba_users b on a.parsing_schema_id = b.user_id where executions>0 and a.parsing_schema_id not in (0,5)
order by a.executions desc) 
where ROWNUM < 21;



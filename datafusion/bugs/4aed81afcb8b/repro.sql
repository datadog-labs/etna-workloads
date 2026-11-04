SET datafusion.execution.target_partitions = 4;
create table duplicate_grouping_sets(deptno int, job varchar, sal int, comm int) as values
(10, 'CLERK', 1300, null),
(20, 'MANAGER', 3000, null);

select deptno, job, sal, sum(comm), grouping(deptno), grouping(job), grouping(sal)
from duplicate_grouping_sets
group by grouping sets ((deptno, job), (deptno, sal), (deptno, job))
order by deptno, job, sal, grouping(deptno), grouping(job), grouping(sal);

select deptno, job, sal, grouping(deptno, job, sal)
from duplicate_grouping_sets
group by grouping sets ((deptno, job), (deptno, sal), (deptno, job))
order by deptno, job, sal, grouping(deptno, job, sal);

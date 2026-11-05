create table g2(a int, b int);
insert into g2 values (1,1),(1,2),(1,3),(2,4);
select a,count(*) from g2 group by rollup(a) having a is distinct from 1 order by a;
explain (costs off) select a,count(*) from g2 group by rollup(a) having a is distinct from 1 order by a;

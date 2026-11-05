create table hp_prefix_test (a int, b int, c int, d int)
  partition by hash (a, b, c, d);
select 'create table hp_prefix_test_p' || x::text || ' partition of hp_prefix_test for values with (modulus 8, remainder ' || x::text || ');'
from generate_Series(0,7) x;
\gexec
insert into hp_prefix_test
select case a when 0 then null else 1 end, case b when 0 then null else 2 end,
  case c when 0 then null else 3 end, case d when 0 then null else 4 end
from generate_series(0,1) a, generate_series(0,1) b, generate_Series(0,1) c, generate_Series(0,1) d;
\t on
select
  'explain (costs off) select tableoid::regclass,* from hp_prefix_test where ' ||
  string_agg(c.colname || case when g.s & (1 << c.colpos) = 0 then ' is null' else ' = ' || (colpos+1)::text end, ' and ' order by c.colpos)
from (values('a',0),('b',1),('c',2),('d',3)) c(colname, colpos), generate_Series(0,15) g(s)
group by g.s order by g.s;
\gexec

create temp table t1(a int, b int);
create temp table t2(a int, b int);
create temp table t3(x int, y int);
select t1.*, t2.*, unnamed_join.* from
  t1 join t2 on (t1.a = t2.a), t3 as unnamed_join
  for update of unnamed_join;
select foo.*, unnamed_join.* from
  t1 join t2 using (a) as foo, t3 as unnamed_join
  for update of foo;

create table t(a int, b int);
create table s(a int, b int);
explain (verbose, costs off) merge into t using s on t.a=s.a
when matched and s.b > 0 then update set b = t.b + s.b;

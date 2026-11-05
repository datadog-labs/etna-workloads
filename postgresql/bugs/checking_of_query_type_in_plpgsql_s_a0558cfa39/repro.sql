create function f1() returns setof int language plpgsql as $$ begin return query execute 'create temp table tt(a int)'; end $$;
select * from f1();
create function f2() returns setof int language plpgsql as $$ begin return query execute 'select 1 where false'; end $$;
select * from f2();
create temp table t2(a int);
create function f3() returns setof int language plpgsql as $$ begin return query execute 'insert into t2 values (1)'; end $$;
select * from f3();

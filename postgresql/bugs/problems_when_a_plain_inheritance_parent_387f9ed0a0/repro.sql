create table some_tab (f1 int, f2 int, f3 int, check (f1 < 10) no inherit);
create table some_tab_child () inherits(some_tab);
insert into some_tab_child select i, i+1, 0 from generate_series(1,1000) i;
create index on some_tab_child(f1, f2);
create function some_tab_stmt_trig_func() returns trigger as
$$begin raise notice 'updating some_tab'; return NULL; end;$$
language plpgsql;
create trigger some_tab_stmt_trig
  before update on some_tab execute function some_tab_stmt_trig_func();
update some_tab set f3 = 11 where f1 = 12 and f2 = 13;
select * from some_tab where f1=12;

create table parent (a int primary key, f int references parent) partition by list (a);
create table child1 partition of parent for values in (1);
alter table parent disable trigger all;
select tgrelid::regclass, rtrim(tgname, '0123456789') as tgname, tgfoid::regproc, tgenabled
  from pg_trigger where tgrelid in ('parent'::regclass, 'child1'::regclass)
  order by tgrelid::regclass::text, tgfoid;

create table p (a int);
create table c () inherits (p);
insert into p values (1);
alter table p add constraint ck check (a = 2) no inherit not valid;
alter table p validate constraint ck;
delete from only p;
alter table p validate constraint ck;
select convalidated from pg_constraint where conrelid = 'p'::regclass and conname = 'ck';

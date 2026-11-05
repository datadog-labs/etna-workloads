create table p(a int);
create table c() inherits(p);
alter table p add constraint nn not null a no inherit;
alter table p alter a set not null;
alter table p add constraint nn2 not null a;
select conname, connoinherit from pg_constraint where conrelid='p'::regclass order by 1;
select conname, connoinherit from pg_constraint where conrelid='c'::regclass order by 1;

create table anothertab(f1 int primary key, f2 int unique, f3 int, f4 int, f5 int);
alter table anothertab add exclude using btree (f3 with =);
alter table anothertab add exclude using btree (f4 with =) where (f4 is not null);
alter table anothertab add exclude using btree (f4 with =) where (f5 > 0);
alter table anothertab add unique(f1,f4);
create index on anothertab(f2,f3);
create unique index on anothertab(f4);
alter table anothertab alter column f1 type bigint;
alter table anothertab alter column f2 type bigint, alter column f3 type bigint, alter column f4 type bigint;
alter table anothertab alter column f5 type bigint;
\d anothertab

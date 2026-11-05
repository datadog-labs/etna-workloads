create table t (a int);
insert into t values (1);
alter table t add primary key (a);
\d t

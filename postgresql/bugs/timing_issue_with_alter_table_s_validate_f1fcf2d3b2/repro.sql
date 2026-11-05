create table t(a int primary key, b int);
insert into t values(1,1);
alter table t add constraint fkc foreign key(b) references t not valid;
alter table t alter a type bigint, alter b type bigint, validate constraint fkc;
create table c(a int);
insert into c values(1);
alter table c add constraint cc check (a>0) not valid;
alter table c alter a type bigint, validate constraint cc;

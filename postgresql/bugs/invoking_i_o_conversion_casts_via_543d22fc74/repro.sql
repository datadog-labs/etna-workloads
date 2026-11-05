create table t1(a int, name text);
insert into t1 values (1,'x');
create table t2(id int, t t1);
insert into t2 values (1, row(1,'x'));
select name(t2.t) from t2;
select t2.t.name from t2;
select text(t1.*) from t1;

create domain pos_ints as int[] check (value[1] > 0);
create table t (f1 int, f2 pos_ints);
insert into t (f2[1], f2[2]) values (3,4), (5,6);
select * from t;

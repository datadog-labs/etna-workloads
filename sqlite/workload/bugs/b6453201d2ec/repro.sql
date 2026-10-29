create table t1(id int);
insert into t1(id) values(1),(2),(3),(4),(5);
create index t1_idx_id on t1(id asc);
select * from t1 group by id order by id desc;

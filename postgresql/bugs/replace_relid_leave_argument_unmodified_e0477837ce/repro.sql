create table emp1 (id int primary key, code int);
explain (costs off)
select * from emp1 t1
   inner join emp1 t2 on t1.id = t2.id
    left join emp1 t3 on t1.id > 1 and t1.id < 2;

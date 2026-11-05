create table emp1 (id int primary key, code int);
explain (costs off)
select * from emp1 t1 left join
    (select coalesce(t3.code, 1) from emp1 t2
        left join (emp1 t3 join emp1 t4 on t3.id = t4.id)
        on true)
on true;

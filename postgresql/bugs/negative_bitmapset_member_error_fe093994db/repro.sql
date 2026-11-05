create temp table emp1 (id int primary key, code text);
explain (costs off)
select 1 from emp1 t1 left join
    ((select 1 as x, * from emp1 t2) s1 inner join
        (select * from emp1 t3) s2 on s1.id = s2.id)
    on true
where s1.x = 1;

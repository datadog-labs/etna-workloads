create table emp1 (id int primary key, code int);
insert into emp1 values (1,1);
insert into emp1 values (2,1);
select * from emp1 t1 where exists (select * from emp1 t2
                                    where t2.id = t1.code and t2.code > 0) order by 1;

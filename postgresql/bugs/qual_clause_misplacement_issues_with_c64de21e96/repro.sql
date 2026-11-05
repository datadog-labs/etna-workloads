create table a(f1 int); create table b(f1 int); create table c(q1 int, q2 int);
insert into a values (0),(1); insert into b values (0),(5); insert into c values (0,0),(5,1);
select * from a, lateral (select * from b left join c on (b.f1 = q1 and a.f1 = q2)) ss order by 1,2;

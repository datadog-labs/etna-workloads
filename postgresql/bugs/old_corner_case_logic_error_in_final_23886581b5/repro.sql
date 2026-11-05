create table j1 (id int primary key);
create table j2 (id int primary key);
create table j3 (id int);
insert into j1 values(1),(2),(3);
insert into j2 values(1),(2),(3);
insert into j3 values(1),(1);
analyze j1; analyze j2; analyze j3;
explain (costs off)
select * from j1 inner join (select distinct id from j3) j3 on j1.id = j3.id;
explain (costs off)
select * from j1 inner join (select id from j3 group by id) j3 on j1.id = j3.id;

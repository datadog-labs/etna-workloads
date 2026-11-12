.mode list
.nullvalue NULL
create table amt(id int, amount decimal(15,2));
insert into amt values (1,10),(2,20),(3,1),(4,2);
create table a(id int);
insert into a values (1),(3);
create table b(id int);
insert into b values (2),(4);
create view v as select amt.id,
  case when a.id is not null then 'A' when b.id is not null then 'B' end as typ,
  case when a.id is not null then amount end as a_amt,
  case when b.id is not null then amount end as b_amt
  from amt left join a on a.id = amt.id left join b on b.id = amt.id;
select (select sum(a_amt) from v where typ in ('A','B')),
       (select sum(b_amt) from v where typ in ('A','B'));

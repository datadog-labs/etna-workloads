create table tt11 (x int, y int);
create table tt12 (x int, z int);
create table tt13 (z int, q int);
create view vv6 as select x,y,z,q from
  (tt11 join tt12 using(x)) join tt13 using(z);
alter table tt11 add column z int;
select pg_get_viewdef('vv6', true);

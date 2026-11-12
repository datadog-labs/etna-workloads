.mode list
.nullvalue NULL
SET threads=1;
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
create table a(ida int, valuea int);
create table b(idb int, valueb int);
create table c(idc int, valuec int);
insert into a values (1,1), (2,2), (1,1),(NUll, NULL),(3, NULL),(NULL,4);
insert into b values (1,1), (2,2), (3,3),(4,4),(3,3),(NUll, NULL),(3, NULL),(NULL,4);
insert into c values (1,1), (2,2), (3,3),(4,4),(3,3),(NUll, NULL),(3, NULL),(NULL,4);
explain select distinct b.* from b left join a on a.ida=b.idb;
explain select distinct b.* from b left join a on a.ida=b.idb where b.valueb=1;
explain select distinct b.* from b left join a on a.ida=b.idb where a.valuea=1;
explain select  b.* from b left join (select distinct ida as ida from a) as a1 on a1.ida=b.idb;
explain select  b.* from b left join (select * from a group by all) as a1 on b.idb=a1.ida;
explain select  b.* from b left join (select a.ida from a group by ida) as a1 on b.idb=a1.ida;
explain select b.idb,sum(b.valueb) from b left join a on b.idb=a.ida group by b.idb;
explain select b.idb,sum(a.valuea) from b left join a on b.idb=a.ida group by b.idb;
explain select  b.* from b left join (select distinct ida as ida from a) as a1 on a1.ida=b.idb and a1.ida = 1;
explain select  b.* from b left join (select distinct ida as ida from a) as a1 on a1.ida=b.idb and a1.ida = b.valueb ;
explain select  b.* from b left join (select distinct ida as ida, valuea as valuea from a) as a1 on a1.ida=b.idb and a1.ida = b.valueb and a1.valuea = b.idb;
explain select  b.* from b left join (select distinct ida as ida, valuea as valuea from a) as a1 on a1.ida=b.idb;
explain select  b.* from b left join (select distinct ida as ida from a) as a1 on a1.ida=b.idb or a1.ida = 1 ;
explain select b.*, a.* from b left join a on a.ida=b.idb;
explain select b.* from b left join a on a.ida=b.idb+1;
explain select tan(b.idb) from b left join a on a.ida=b.idb;
explain select b.valueb from b left join a on a.ida=b.idb;
explain select b.*, tan(a.ida) from b left join a on a.ida=b.idb;
explain SELECT c.* 
  FROM c 
  LEFT JOIN (
      SELECT DISTINCT b.* 
      FROM b 
      LEFT JOIN a ON a.ida = b.idb
  ) AS ab ON c.idc = ab.idb;
explain SELECT c.* 
  FROM c 
  LEFT JOIN (
      SELECT DISTINCT b.* 
      FROM b 
      LEFT JOIN a ON a.ida = b.idb
  ) AS ab ON c.idc = ab.idb and c.valuec = ab.valueb;
explain select b.*, tan(a.ida) from b left join a on a.ida=b.idb;
select distinct b.* from b left join a on a.ida=b.idb;
select distinct b.* from b left join a on a.ida=b.idb where b.valueb=1;
select distinct b.* from b left join a on a.ida=b.idb where a.valuea=1;
select  b.* from b left join (select distinct ida as ida from a) as a1 on a1.ida=b.idb;
select  b.* from b left join (select * from a group by all) as a1 on b.idb=a1.ida;
select  b.* from b left join (select a.ida from a group by ida) as a1 on b.idb=a1.ida;
select b.idb,sum(b.valueb) from b left join a on b.idb=a.ida group by b.idb;
select b.idb,sum(a.valuea) from b left join a on b.idb=a.ida group by b.idb;
select  b.* from b left join (select distinct ida as ida from a) as a1 on a1.ida=b.idb and a1.ida = 1;
select  b.* from b left join (select distinct ida as ida from a) as a1 on a1.ida=b.idb and a1.ida = b.valueb ;
select  b.* from b left join (select distinct ida as ida, valuea as valuea from a) as a1 on a1.ida=b.idb and a1.ida = b.valueb and a1.valuea = b.idb;
select  b.* from b left join (select distinct ida as ida, valuea as valuea from a) as a1 on a1.ida=b.idb;
select  b.* from b left join (select distinct ida as ida from a) as a1 on a1.ida=b.idb or a1.ida = 1 ;
select b.*, a.* from b left join a on a.ida=b.idb;
select b.* from b left join a on a.ida=b.idb+1;
select tan(b.idb) from b left join a on a.ida=b.idb;
select b.valueb from b left join a on a.ida=b.idb;
select b.*, tan(a.ida) from b left join a on a.ida=b.idb;
SELECT c.* 
  FROM c 
  LEFT JOIN (
      SELECT DISTINCT b.* 
      FROM b 
      LEFT JOIN a ON a.ida = b.idb
  ) AS ab ON c.idc = ab.idb;
SELECT c.* 
  FROM c 
  LEFT JOIN (
      SELECT DISTINCT b.* 
      FROM b 
      LEFT JOIN a ON a.ida = b.idb
  ) AS ab ON c.idc = ab.idb and c.valuec = ab.valueb;
select b.*, tan(a.ida) from b left join a on a.ida=b.idb;
explain 
  select b.* from b left join (select distinct a.ida from a ) as a on a.ida=b.idb union all select b.*  from b left join (select distinct a.ida from a ) as a on a.ida=b.idb;
select b.* from b left join (select distinct a.ida from a ) as a on a.ida=b.idb union all select b.*  from b left join (select distinct a.ida from a ) as a on a.ida=b.idb;
select a.ida from (select ida from a group by ida) as a left join b on ida < idb;
explain select a.ida from (select ida from a group by ida) as a left join b on ida < idb;
select a.ida from b right join (select ida from a group by ida) as a on ida < idb;
explain select a.ida from b right join (select ida from a group by ida) as a on ida < idb;
create table dup_keys(k int);
insert into dup_keys values (1),(1),(2),(3);
create table probe_keys(idb int);
insert into probe_keys values (1),(1),(2),(3),(4),(NULL),(2),(3);
select count(*) from probe_keys left join (select k, unnest([1,2,3]) e from (select distinct k from dup_keys) s) t on t.k=probe_keys.idb;

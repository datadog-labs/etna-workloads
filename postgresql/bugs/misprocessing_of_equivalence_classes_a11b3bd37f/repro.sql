create type mycomptype as (id int, v bigint);
create temp table tidv (idv mycomptype);
create index on tidv (idv);
explain (costs off)
select a.idv, b.idv from tidv a, tidv b where a.idv = b.idv;

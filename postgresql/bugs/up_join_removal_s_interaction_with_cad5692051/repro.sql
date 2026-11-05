create table int8_tbl(q1 int8, q2 int8);
insert into int8_tbl values (123,456),(123,4567890123456789),(4567890123456789,123);
create table int4_tbl(f1 int);
insert into int4_tbl values (0),(123456);
create table tenk1(unique1 int unique, unique2 int unique);
insert into tenk1 select i, i from generate_series(0,9999) i;
create table innertab(id int8 primary key, dat1 int8);
insert into innertab values (123, 42);
analyze;
explain (costs off)
select * from int4_tbl
     JOIN ((SELECT 42 AS x FROM int8_tbl LEFT JOIN innertab ON q1 = id) AS ss1
           RIGHT JOIN tenk1 ON NULL)
        ON tenk1.unique1 = ss1.x OR tenk1.unique2 = ss1.x;
EXPLAIN (VERBOSE, COSTS OFF)
SELECT q2 FROM
  (SELECT q2, 'constant'::text AS x
   FROM int8_tbl LEFT JOIN innertab ON q2 = id) ss
  RIGHT JOIN int4_tbl ON NULL
 WHERE x >= x;

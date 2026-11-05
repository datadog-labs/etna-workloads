create temp table int4_tbl(f1 int);
create temp table int8_tbl(q1 int8, q2 int8);
explain (verbose, costs off)
select table_catalog, table_name
from int4_tbl t1
  inner join (int8_tbl t2
              left join information_schema.column_udt_usage on null)
  on null;

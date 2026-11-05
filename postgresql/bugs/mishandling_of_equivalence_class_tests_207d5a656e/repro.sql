create table tenk1 as select i as unique1, i%1000 as thousand, i as tenthous from generate_series(0,9999) i;
create index tenk1_thous_tenthous on tenk1(thousand, tenthous);
create table int4_tbl(f1 int);
insert into int4_tbl values (0),(123456),(-123456),(2147483647),(-2147483647);
vacuum analyze tenk1; analyze int4_tbl;
explain (costs off)
select a.f1, b.f1, t.thousand, t.tenthous from
  tenk1 t,
  (select sum(f1)+1 as f1 from int4_tbl i4a) a,
  (select sum(f1) as f1 from int4_tbl i4b) b
where b.f1 = t.thousand and a.f1 = b.f1 and (a.f1+b.f1+999) = t.tenthous;

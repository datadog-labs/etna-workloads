create temp table tbl1(a int, b int);
create temp table tbl2(c int, d int);
create temp table tbl3(e int, f int);
create temp table tbl4(g int, h int);
create view view_of_joins as
select * from
  (select * from (tbl1 cross join tbl2) same) ss,
  (tbl3 cross join tbl4) same;
select pg_get_viewdef('view_of_joins');

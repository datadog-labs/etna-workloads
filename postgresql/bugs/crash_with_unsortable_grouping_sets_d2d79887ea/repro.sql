create temp table gstest4(id integer, v integer, unhashable_col bit(4), unsortable_col xid);
insert into gstest4 values (1,1,B'0000','1'),(2,2,B'0001','1'),(3,4,B'0010','2'),(4,8,B'0011','2');
select unsortable_col, count(*)
  from gstest4 group by grouping sets ((unsortable_col),(unsortable_col))
  order by unsortable_col::text;

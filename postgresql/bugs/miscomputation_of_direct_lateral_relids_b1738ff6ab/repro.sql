create temp table i4(f1 int);
insert into i4 values (123456),(2147483647),(0);
create temp table i8(a int);
insert into i8 values (1),(2);
select count(*) from
  i4 as i41,
  lateral
    (select 1 as x from
      (select i41.f1 as lat, i42.f1 as loc from
         i8 as i81, i4 as i42) as ss1
      right join i4 as i43 on (i43.f1 > 1)
      where ss1.loc = ss1.lat) as ss2
where i41.f1 > 0;

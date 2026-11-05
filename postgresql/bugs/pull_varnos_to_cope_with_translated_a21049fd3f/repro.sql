create temp table parttbl (a integer primary key) partition by range (a);
create temp table parttbl1 partition of parttbl for values from (1) to (100);
create temp table i4 (f1 int);
insert into i4 values (0),(1);
insert into parttbl values (11), (12);
select * from
  (select *, 12 as phv from parttbl) as ss
  right join i4 on true
where ss.a = ss.phv and f1 = 0;

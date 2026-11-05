create temp table prtx1 (a integer, b integer, c integer) partition by range (a);
create temp table prtx1_1 partition of prtx1 for values from (1) to (11);
create temp table prtx1_2 partition of prtx1 for values from (11) to (21);
create temp table prtx1_3 partition of prtx1 for values from (21) to (31);
create temp table prtx2 (a integer, b integer, c integer) partition by range (a);
create temp table prtx2_1 partition of prtx2 for values from (1) to (11);
create temp table prtx2_2 partition of prtx2 for values from (11) to (21);
create temp table prtx2_3 partition of prtx2 for values from (21) to (31);
insert into prtx1 select 1 + i%30, i, i from generate_series(1,1000) i;
insert into prtx2 select 1 + i%30, i, i from generate_series(1,500) i, generate_series(1,10) j;
create index on prtx2 (b);
create index on prtx2 (c);
analyze prtx1;
analyze prtx2;
explain (costs off)
select * from prtx1
where not exists (select 1 from prtx2
                  where prtx2.a=prtx1.a and prtx2.b=prtx1.b and prtx2.c=123)
  and a<20 and c=120;
select * from prtx1
where not exists (select 1 from prtx2
                  where prtx2.a=prtx1.a and prtx2.b=prtx1.b and prtx2.c=123)
  and a<20 and c=120;
explain (costs off)
select * from prtx1
where not exists (select 1 from prtx2
                  where prtx2.a=prtx1.a and (prtx2.b=prtx1.b+1 or prtx2.c=99))
  and a<20 and c=91;
select * from prtx1
where not exists (select 1 from prtx2
                  where prtx2.a=prtx1.a and (prtx2.b=prtx1.b+1 or prtx2.c=99))
  and a<20 and c=91;

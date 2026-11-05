create temp table text_tbl(f1 text);
insert into text_tbl values ('doh!'),('hi de ho neighbor');
create temp table int8_tbl(q1 int8, q2 int8);
insert into int8_tbl values (123,456),(123,4567890123456789),(4567890123456789,123),(4567890123456789,4567890123456789),(4567890123456789,-4567890123456789);
create temp table int4_tbl(f1 int4);
insert into int4_tbl values (0),(123456);
select t1.* from
  text_tbl t1
  left join (select *, '***'::text as d1 from int8_tbl i8b1) b1
    left join int8_tbl i8
      left join (select *, null::int as d2 from int8_tbl i8b2) b2
      on (i8.q1 = b2.q1)
    on (b2.d2 = b1.q2)
  on (t1.f1 = b1.d1)
  left join int4_tbl i4
  on (i8.q2 = i4.f1);

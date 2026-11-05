create temp table t8(q1 int8, q2 int8);
insert into t8 values (123,456),(123,4567890123456789),(4567890123456789,123),(4567890123456789,4567890123456789),(4567890123456789,-4567890123456789);
select distinct q1 from
  (select distinct * from t8 i81
   union all
   select distinct * from t8 i82) ss
where q2 = q2;
explain (costs off)
select distinct q1 from
  (select distinct * from t8 i81
   union all
   select distinct * from t8 i82) ss
where -q1 = q2;
select distinct q1 from
  (select distinct * from t8 i81
   union all
   select distinct * from t8 i82) ss
where -q1 = q2;

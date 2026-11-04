select
  coalesce(2, arrow_cast(3, 'UInt64')),
  arrow_typeof(coalesce(2, arrow_cast(3, 'UInt64')));

create table t (v bigint unsigned);
insert into t values (10000000000000000000), (18446744073709551615);
insert into t values (10000000000000000001), (1), (10000000000000000002);
select * from t order by v;

select arrow_typeof(arrow_cast(1, 'UInt64') + arrow_cast(1, 'Int64'));
select arrow_cast(18446744073709551615, 'UInt64') = arrow_cast(-1, 'Int64');

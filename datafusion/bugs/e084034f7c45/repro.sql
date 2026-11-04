create table any_value_empty (id int, tags bigint[]) as values
  (1, make_array(10)),
  (2, cast(make_array() as bigint[])),
  (3, make_array(20, 30)),
  (4, cast(make_array() as bigint[]));

select id, array_any_value(tags) from any_value_empty order by id;

select id, array_any_value(arrow_cast(tags, 'LargeList(Int64)')) from any_value_empty order by id;

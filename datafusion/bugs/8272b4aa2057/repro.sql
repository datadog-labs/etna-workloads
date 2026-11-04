select array_resize(make_array(1), 9223372036854775807, 0);
select array_resize(arrow_cast(make_array(1), 'LargeList(Int64)'), 9223372036854775807, 0);
select array_resize(arrow_cast(make_array('a'), 'LargeList(Utf8)'), 600000000000000000);

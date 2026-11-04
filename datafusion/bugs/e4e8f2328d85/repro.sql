select array_remove_n(make_array(1, 2, 2, 1, 1), 2, NULL),
       array_remove_n(make_array(1, 2, 2, 1, 1), 2, 2);
select array_remove_n(arrow_cast(make_array(1, 2, 2, 1, 1), 'LargeList(Int64)'), 2, NULL),
       array_remove_n(arrow_cast(make_array(1, 2, 2, 1, 1), 'LargeList(Int64)'), 2, 2);

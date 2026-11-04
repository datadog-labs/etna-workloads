select array_concat(make_array(1, 2), arrow_cast([3, 4], 'LargeList(Int64)')),
    arrow_typeof(array_concat(make_array(1, 2), arrow_cast([3, 4], 'LargeList(Int64)')));
select array_concat(arrow_cast([1, 2], 'LargeList(Int64)'), make_array(3, 4));
select array_concat(arrow_cast([1, 2], 'FixedSizeList(2, Int64)'), arrow_cast([3, 4], 'LargeList(Int64)'));
select array_concat(make_array(1, 2), arrow_cast([3], 'LargeList(Int64)'), make_array(4, 5));

select empty(arrow_cast(make_array(), 'FixedSizeList(0, Null)'));
select arrow_cast([], 'FixedSizeList(0, Null)');
select arrow_cast(a, 'FixedSizeList(0, Null)') from values ([]), (NULL) t(a) order by 1;
select arrow_cast('1', 'FixedSizeList(1, Int64)');

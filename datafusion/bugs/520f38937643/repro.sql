select
  array_append(arrow_cast(column1, 'List(Int64, field: ''element'')'), 4),
  arrow_typeof(array_append(arrow_cast(column1, 'List(Int64, field: ''element'')'), 4))
from values (make_array(1, 2, 3));

select
  array_prepend(0, arrow_cast(column1, 'LargeList(Int64, field: ''element'')')),
  arrow_typeof(array_prepend(0, arrow_cast(column1, 'LargeList(Int64, field: ''element'')')))
from values (make_array(1, 2, 3));

select
  array_append(arrow_cast(column1, 'LargeList(non-null Int64)'), 4),
  arrow_typeof(array_append(arrow_cast(column1, 'LargeList(non-null Int64)'), 4))
from values (make_array(1, 2, 3));

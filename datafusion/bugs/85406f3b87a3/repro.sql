select array_slice(column1, 2, 3), arrow_typeof(array_slice(column1, 2, 3))
from values
  (arrow_cast([], 'List(non-null Int32)')),
  (arrow_cast(NULL, 'List(non-null Int32)')),
  (arrow_cast([1, 3, 5, -5], 'List(non-null Int32)'));
select array_pop_front(column1), array_pop_back(column1), arrow_typeof(array_pop_front(column1))
from values
  (arrow_cast([], 'LargeList(non-null Int32)')),
  (arrow_cast(NULL, 'LargeList(non-null Int32)')),
  (arrow_cast([1, 3, 5, -5], 'LargeList(non-null Int32)'));

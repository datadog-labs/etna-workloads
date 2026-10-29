Reproducer (`repro.sql`) is the indexexpr1-2200 case: a GROUP BY aggregate subquery (MAX(t2.value) grouped by t2.type, t1.tag) joined to another subquery, with an index on the expression -tag.

Clean shell: `7|100` / `8|101`. Buggy shell: `7|7` / `8|8` (wrong result: max_value reads the wrong sorter column because nSortingColumn is computed incorrectly in optimizeAggregateUseOfIndexedExpr).

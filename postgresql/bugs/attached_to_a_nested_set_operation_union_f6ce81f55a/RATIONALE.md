# Rationale
Changed: src/backend/parser/analyze.c, transformSetOperationStmt and transformSetOperationTree
(traces to the analyze.c hunks of fix.patch).
- transformSetOperationStmt: the WITH clause is again processed at the top, before the leftmost-select search, and is no longer extracted from / cleared on the stmt (the `withClause` local is removed).
- transformSetOperationTree: isLeaf no longer considers stmt->withClause, so an inner set-op node with its own WITH is flattened into a SetOperationStmt instead of becoming a sub-Query, and its WITH is ignored or misattributed.
Only analyze.c is changed. The other fix hunks are field reordering, which doesn't affect behavior, plus parse_cte.c changes for recursion checks.

Oracle case expected to fail: src/test/regress||with

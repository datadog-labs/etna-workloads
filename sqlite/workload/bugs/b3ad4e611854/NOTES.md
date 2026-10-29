repro.sql runs the select4-19.1 query. The WHERE 0 is pushed down into the subquery, and sqlite3ExprAnd() frees an expression that AggInfo.aCol[].pCExpr still points to.
The debug-build AggInfo check at the end of sqlite3Select() then reads freed memory, so the buggy shell hits an assertion failure or crash. The clean shell prints a single empty row.

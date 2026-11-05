Hunk: src/backend/nodes/nodeFuncs.c, expression_returns_set_walker() -> the single fix.patch hunk.
The fix removed early "return false" shortcuts for DistinctExpr, NullIfExpr, ScalarArrayOpExpr, BoolExpr, SubLink, SubPlan, AlternativeSubPlan, ArrayExpr, RowExpr, RowCompareExpr, CoalesceExpr, MinMaxExpr, SQLValueFunction, XmlExpr. I re-added them. A set-returning function nested in the arguments of these nodes (e.g. COALESCE(srf(), 1)) is no longer detected as returning a set.
Failing oracle case: src/test/regress||tsrf

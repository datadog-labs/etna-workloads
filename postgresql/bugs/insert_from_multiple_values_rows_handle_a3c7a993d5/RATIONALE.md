# Rationale
File: src/backend/parser/analyze.c, function transformInsertStmt (the fix's ruleutils.c and catversion hunks are not touched; the bug is restored in the parser alone).

1. Multi-VALUES branch: transformInsertRow(..., strip_indirection) is now called with `false` instead of `true`. This traces to the fix.patch hunk that added the `true` argument. Each VALUES row keeps its FieldStore/SubscriptingRef assignment nodes again, instead of having them stripped.
2. Removed the "Re-apply any indirection on the target column specs to the Vars" transformInsertRow call after the Vars for the VALUES RTE are generated. This traces to the fix.patch hunk that added that call. The top targetlist no longer carries the indirection, so deparse (ruleutils) cannot print the column-name decoration, and the indirection nodes sit inside the VALUES rows.

Failing oracle case: src/test/regress||insert

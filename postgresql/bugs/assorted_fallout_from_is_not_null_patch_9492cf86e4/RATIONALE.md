# Rationale
- src/backend/utils/adt/ruleutils.c, get_rule_expr (T_NullTest): traces to the ruleutils.c hunk of fix.patch. Removed the argisrow/type_is_rowtype check so a scalar NullTest on a rowtype input is deparsed as plain IS [NOT] NULL instead of IS [NOT] DISTINCT FROM NULL. This is semantically wrong (reparsing gives the row-wise test) and changes the output of the regression test.

Failing oracle case: src/test/regress||rowtypes

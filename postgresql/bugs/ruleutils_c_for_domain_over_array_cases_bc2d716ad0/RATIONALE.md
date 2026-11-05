# Rationale

All changes are in src/backend/utils/adt/ruleutils.c, and they reverse the hunks of fix_impl.patch.

1. `get_update_query_targetlist_def`: removed the `else if (IsA(expr, CoerceToDomain))` branch.
   This is the fix hunk that lets the dig-down loop descend through implicit CoerceToDomain nodes.
   Without it, a PARAM_MULTIEXPR Param buried under a domain-over-array coercion isn't found.
2. `processIndirection`: removed the `CoerceToDomain` branch, the `cdomain` variable, and the back-up
   logic after the loop. These correspond to the three processIndirection hunks in the fix.
   Without them, deparse can't see array or field assignments under an implicit domain coercion.
   An UPDATE that assigns to an element or field of a domain-over-array column is deparsed wrongly.

Failing oracle case: src/test/regress||domain

# Rationale

## Changed hunk
- File: src/backend/utils/adt/ruleutils.c, function `colname_is_unique`.
- Traces to the fix.patch hunk in ruleutils.c that adds `colname_is_unique` (the "Also check against USING-column names that must be globally unique" loop over `dpns->using_names`). That is the logic for `unique_using` and `using_names`.
- Change: removed the loop over `dpns->using_names`.
- Why this brings the bug back: merged FULL JOIN USING column names are no longer forced to be globally unique across the query. Other columns can then be given the same alias, so deparsed views and rules have ambiguous or conflicting column references. That is the conflict the fix removed.

## Failing oracle cases
- src/test/regress||create_view

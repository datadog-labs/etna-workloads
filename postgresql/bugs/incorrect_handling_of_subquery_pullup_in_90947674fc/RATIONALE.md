# Rationale

Changed hunk: `src/backend/optimizer/prep/prepjointree.c`, `pull_up_simple_subquery()`.
Traces to the fix.patch hunk that added `if (parse->groupingSets) { need_phvs = true; wrap_non_vars = true; }`.
In current code that is `if (parse->groupingSets) rvcontext.wrap_option = REPLACE_WRAP_ALL;`, which I removed.
Without it, pulled-up subquery output expressions are not wrapped in PlaceHolderVars when the parent uses grouping sets. They lose their separate identity and no longer match grouping set columns, so the plan is wrong.

Failing oracle case: src/test/regress||groupingsets

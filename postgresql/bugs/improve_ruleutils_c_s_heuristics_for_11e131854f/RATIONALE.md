# Rationale

## Changed hunk
File: src/backend/utils/adt/ruleutils.c, function `select_rtable_names_for_explain`.
Change: `set_rtable_names(&dpns, NIL, rels_used)` became `set_rtable_names(&dpns, NIL, NULL)`.

Traces to the fix.patch hunk in ruleutils.c that added `select_rtable_names_for_explain`. That function passes
`rels_used` (built by ExplainPreScanNode in explain.c) so that only RTEs that appear in the plan get aliases.

Why it brings the bug back: the fix gives aliases only to RTEs that EXPLAIN actually references. Passing NULL
assigns aliases to every RTE, including unreferenced ones such as inheritance parents. Those RTEs take the
unsuffixed names, and the RTEs that do appear in the plan get "_1" and similar suffixes. This is the
confusing EXPLAIN alias output the commit message describes.

## Failing oracle cases
- src/test/regress||aggregates
- src/test/regress||alter_table
- src/test/regress||inherit
- src/test/regress||select_views

create_view and with still pass.

# Rationale

File: src/backend/optimizer/plan/subselect.c, function SS_process_ctes.
Traces to the fix_impl.patch hunk that added `(cte->cterefcount <= 1 || !contain_outer_selfref(cte->ctequery))` to the inlining condition. I removed that clause. Multiply-referenced CTEs (e.g. MATERIALIZED-never) that contain an outer recursive self-reference are inlined again, which produces multiple recursive self-references, and that isn't supported. The helper contain_outer_selfref is left in place but is now unused. The other hunks of the fix only add the helper and comments.

Failing oracle case: src/test/regress||subselect

# Rationale

Changed hunk: `src/backend/parser/analyze.c`, `stmt_requires_parse_analysis()`.
Traces to the fix.patch hunk in analyze.c that added `case T_CallStmt:` to the "requires parse analysis" list, which the fix replaced the old "yes, because we must analyze the contained statement" comment with.
I removed `case T_CallStmt:`, so CALL is classed as a statement that never needs parse analysis.
`StmtPlanRequiresRevalidation()` in plancache.c then returns false for CALL. Cached CALL plans are never revalidated or invalidated, and they also skip the snapshot decision in `analyze_requires_snapshot()`. That breaks CALL in the plpgsql tests.

Failing oracle case: src/pl/plpgsql/src||plpgsql_call

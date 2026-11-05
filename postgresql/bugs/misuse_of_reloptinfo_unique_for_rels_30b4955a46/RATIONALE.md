# Rationale
Reverts the SJE cache fix in `innerrel_is_unique_ext()` (src/backend/optimizer/plan/analyzejoins.c), tracing to the same-named hunks in fix_impl.patch:
- Removed `self_join` local; cache lookup again matches any subset outerrel (no exact-match / self_join-flag requirement), so results cached from non-self-join checks (unfiltered clauses, no valid extra_clauses) are reused for self-join checks and vice versa.
- `is_innerrel_unique_for()` always gets `&outer_exprs`; new cache entries no longer record `self_join`.
- src/include/nodes/pathnodes.h: removed `UniqueRelInfo.self_join` field (header hunk).
Comment-only hunk left alone.

Failing oracle case: src/test/regress||join (see oracle output).

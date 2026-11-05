# Rationale

File: src/backend/partitioning/partprune.c, function gen_prune_steps_from_opexps (LIST/RANGE case).

Traces to the single fix_impl.patch hunk set in that function (the comment-only hunk in get_steps_using_prefix is left as is).
I restored the pre-fix prefix construction:
- A function-level `pk_has_clauses[PARTITION_MAX_KEYS]` array replaces the per-key bool, and the `eq_start`/`le_start`/`ge_start` cursors and `keyno` loop are removed.
- Prefix clauses are collected by scanning the =, <= and >= lists in turn, each for all earlier keys.
  That produces a prefix grouped by strategy instead of sorted ascending by partition key number.
- get_steps_using_prefix expects the prefix sorted by keyno, so with multiple clauses per key, or mixed strategies, it generates wrong or missing pruning steps.
  That is the bug the fix removed.

Oracle case expected to fail: src/test/regress||partition_prune (confirmed: FAIL).

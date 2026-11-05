# Rationale

The fix introduced `incompatible_relids` on RestrictInfo. It is used to filter cloned outer-join quals and is passed through make_restrictinfo. This change re-expresses the pre-fix behavior in today's code.

1. `src/backend/optimizer/util/relnode.c`, `subbuild_joinrel_restrictlist()`
   - Traces to the fix.patch relnode.c hunk, which replaced the `clause_is_computable_at()` test with `bms_overlap(rinfo->incompatible_relids, both_input_relids)`.
   - I removed the overlap check. `clause_is_computable_at` no longer exists in today's code, so I could not restore it. Dropping the check has the same effect: a clone clause that is already too late to evaluate is no longer skipped. Several clones can then be selected, or the wrong one.

2. `src/backend/optimizer/path/equivclass.c`, `reconsider_outer_join_clauses()`, three places (left, right and full join clauses)
   - Traces to the fix.patch equivclass.c hunks.
   - The dummy replacement clause again gets `is_pushed_down=true`, `has_clone=false`, `is_clone=false` and no `incompatible_relids`. It no longer copies the removed clause's properties.

Failing oracle case: `src/test/regress||join`.

I ran the oracle after change 2 alone and `join` still passed. It failed only once change 1 was added, so change 1 is what triggers the failure.

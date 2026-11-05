# Rationale

File: src/backend/optimizer/path/joinpath.c

1. `have_unsafe_outer_join_ref()` — traces to the fix.patch hunks that turn the function into an
   assert-only check with the fixed `satisfied`-based logic. Reverted to the pre-fix version:
   always compiled, no `satisfied` set, and it rejects whenever the unsatisfied part of the
   parameterization overlaps `root->outer_join_rels`. The `NOT_USED` per-sjinfo loop is gone.
   Effect: it rejects valid nestloop paths.
2. `try_nestloop_path()` — traces to the hunk that removed the call from the rejection condition and
   added `Assert(!have_unsafe_outer_join_ref(...))`. Restored the call in the rejection condition and
   removed the Assert. Valid parameterized nestloop paths are now rejected, so plans change.
   (`have_dangerous_phv` no longer exists in this code, so only the unsafe-ref call is restored.)

Failing oracle case: src/test/regress||join

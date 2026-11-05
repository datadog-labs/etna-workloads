# Rationale

Both hunks are in `src/src/backend/optimizer/plan/analyzejoins.c`.

1. `join_is_removable()`, PlaceHolderVar loop. This traces to the first fix.patch hunk.
   I restored the pre-fix PHV test:
   - `ph_needed` is checked after the "doesn't overlap innerrel" test.
   - The `ojrelid`-membership and `min_lefthand`-overlap checks are gone.
   - A PHV with `ph_eval_at` wholly inside innerrel is refused.
   Join removal is therefore no longer checked against the PHV's evaluation location.
   Removable joins whose PHV is used above the join are refused, or other cases are mishandled.

2. `remove_rel_from_restrictinfo()`. This traces to the last fix.patch hunk. The code was refactored since the fix, and that logic now lives here.
   I removed the `clause_relids` cleanup (relid and ojrelid deleted from `clause_relids`).
   A RestrictInfo built from a PHV whose `ph_eval_at` includes the removed rel keeps stale relids in `clause_relids`.
   That breaks later planning or assert checks.

The Assert additions in fix.patch are not restored; the current code already has an equivalent cross-check.

Failing oracle case: `src/test/regress||join`.

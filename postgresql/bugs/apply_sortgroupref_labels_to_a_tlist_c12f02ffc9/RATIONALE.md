# Rationale

## src/backend/optimizer/plan/createplan.c, create_scan_plan() (two hunks)
Traces to both hunks of fix_impl.patch (the two `apply_pathtarget_labeling_to_tlist` calls,
which the fix guarded with `!gating_clauses`). In current code the guard is the
CP_LABEL_TLIST flag (cleared to 0 when gating_clauses exist). I changed both conditions to
`(flags & CP_LABEL_TLIST) || gating_clauses`, so labels are again applied to the physical/index
tlist even when a gating Result will sit on top and the tlist may not match the pathtarget
(e.g. `select max(100) from tenk1`).

## Failing oracle cases
- src/test/regress||aggregates

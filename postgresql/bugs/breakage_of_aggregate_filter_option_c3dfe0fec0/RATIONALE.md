# Rationale

fix_impl.patch targets the old nodeAgg.c ExecProject design. In REL_18 the same
logic lives in compiled expressions (`ExecBuildAggTrans`), so the bug is re-expressed there.

## src/backend/executor/execExpr.c, ExecBuildAggTrans
Traces to the fix.patch nodeAgg.c hunks (advance_aggregates and ExecInitAgg) that
make a FILTER aggregate evaluate its filter first and its arguments only for rows that pass.
The FILTER block is moved from before the argument-evaluation steps to after them,
just before the strict-input check. The filter evaluates into private Datum/bool
storage so it doesn't clobber `state->resvalue` used by single-column sorted input.
Arguments are therefore evaluated for rows the filter rejects, which is the original
bug (side effects and errors from arguments, e.g. division by zero).

## Failing oracle cases
- src/test/regress||aggregates

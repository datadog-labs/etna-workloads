# Rationale

## src/backend/storage/ipc/procarray.c, GlobalVisHorizonKindForRel()
Traces to the procarray.c hunks of fix_impl.patch that added the temp-relation horizon
(`else if (RELATION_IS_LOCAL(rel)) return horizons.temp_oldest_nonremovable;` in
GetOldestNonRemovableTransactionId and `state = &GlobalVisTempRels` in GlobalVisTestFor).
In current code both go through GlobalVisHorizonKindForRel, so removing the
VISHORIZON_TEMP result there (temp rels fall back to the data horizon) reverts the
centralized temp horizon: temp tables are again judged against other sessions' snapshots,
so pruning/vacuum of temp tables is no longer aggressive (and horizons are not the per-session ones).

Failing oracle case: src/test/isolation||horizons

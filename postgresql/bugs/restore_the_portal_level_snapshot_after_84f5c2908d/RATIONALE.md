# Rationale

## Changed hunk
- File: src/backend/executor/spi.c, function `_SPI_execute_plan`.
- Traces to the fix.patch hunk in spi.c that adds `EnsurePortalSnapshotExists()` before the per-statement-list snapshot setup (the "First, ensure there's a Portal-level snapshot" block).
- I removed that call. After a procedure's COMMIT/ROLLBACK in non-atomic mode, `ForgetPortalSnapshots()` has popped all snapshots. Nothing restores the portal-level snapshot for the next statement. SPI relies on the portal snapshot in non-atomic mode, so statements run with no active snapshot. Detoasting then fails, which is what plpgsql-toast exercises.

## Failing oracle cases
- src/test/isolation||plpgsql-toast

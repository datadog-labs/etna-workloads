Reproducer (`repro.sql`): a REAL column receives 5.0 via INSERT ... RETURNING and 6.0 via UPDATE ... RETURNING (DELETE too).
The fix adds OP_RealAffinity in RETURNING, so the clean shell prints `5.0` and `6.0`.
The buggy shell loses the REAL affinity and prints `5` and `6` for INSERT and UPDATE (typeof still says real).
The test uses affinity(), which needs internal functions; the printed value shows the difference without it.

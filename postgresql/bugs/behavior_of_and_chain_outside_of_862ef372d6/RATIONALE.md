# Rationale

File: src/backend/access/transam/xact.c, three hunks. They trace to the three hunks of fix_impl.patch.

- `EndTransactionBlock`, case `TBLOCK_IMPLICIT_INPROGRESS`: removed the `if (chain) ereport(ERROR, "COMMIT AND CHAIN can only be used in transaction blocks")` branch. Only the WARNING is left.
- `EndTransactionBlock`, case `TBLOCK_STARTED`: same removal.
- `UserAbortTransactionBlock`, cases `TBLOCK_STARTED` and `TBLOCK_IMPLICIT_INPROGRESS`: removed the `ROLLBACK AND CHAIN` error. Only the WARNING is left.

Effect: COMMIT/ROLLBACK AND CHAIN outside an explicit transaction block is accepted with a warning instead of raising an error. This is the bug the fix removed.

Failing oracle case: src/test/regress||transactions

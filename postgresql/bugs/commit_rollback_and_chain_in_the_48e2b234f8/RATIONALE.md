# Rationale

File: src/backend/access/transam/xact.c, function CommitTransactionCommandInternal
(traces to the single hunk of fix.patch: the "Must save in case we need to restore below"
SaveTransactionCharacteristics call).

The fix documents that the save must be unconditional. The original bug was an
`if (s->chain)` guard around the save, which examined the wrong transaction state
(the current subtransaction, not the parent whose chain flag was set). I re-added
`if (s->chain)` around SaveTransactionCharacteristics. With an open savepoint,
COMMIT AND CHAIN leaves savetc uninitialized, so the new transaction gets wrong characteristics.

Failing oracle case (expected): src/test/regress||transactions

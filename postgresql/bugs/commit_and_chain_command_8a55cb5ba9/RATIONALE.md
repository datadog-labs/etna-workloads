# Rationale

## src/backend/access/transam/xact.c, CommitTransactionCommand()
Case TBLOCK_SUBCOMMIT, branch `if (s->blockState == TBLOCK_END)`: removed the
`if (s->chain) { StartTransaction(); blockState = TBLOCK_INPROGRESS; chain = false; RestoreTransactionCharacteristics(&savetc); }`
block after `CommitTransaction()`. This reverses the sole hunk of fix.patch, which added it there.
Without it, COMMIT AND CHAIN issued with an open subtransaction commits but does not start the chained transaction.

## Failing oracle cases
src/test/regress||transactions (expected; the oracle run was still in progress when this was written)

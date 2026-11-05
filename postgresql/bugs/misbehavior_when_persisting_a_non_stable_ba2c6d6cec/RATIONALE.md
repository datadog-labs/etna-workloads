# Rationale

File: src/backend/commands/portalcmds.c, function PersistHoldablePortal (single hunk of fix.patch, plus its follow-on adaptations in current code).

- Always call ExecutorRewind(queryDesc) (removing the CURSOR_OPT_SCROLL conditional and the non-scroll branch that only stored not-yet-fetched rows / set NoMovement at end). This is the reverse of the fix's `if (CURSOR_OPT_SCROLL) rewind else store only remaining rows`.
- Removed the CURSOR_OPT_SCROLL guard around tuplestore_skiptuples so the holdStore is always positioned by portalPos, as before the fix (the whole result is always stored).

Why it brings the bug back: a non-scroll holdable cursor re-executes the whole query on persist, so with unstable output (e.g. volatile/random results) the rows after commit differ from the ones already fetched, and the cursor's position is wrong.

Failing oracle case: src/pl/plpgsql/src||plpgsql_transaction

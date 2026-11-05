# Reintroduced bug: ALTER SUBSCRIPTION SET PUBLICATION grammar (REFRESH / SKIP REFRESH)

## Changed hunk
- File: src/src/backend/parser/gram.y, rule `AlterSubscriptionStmt`.
- Traces to the gram.y hunk of fix.patch.
- The fix replaced `SET PUBLICATION list REFRESH opt_definition` and `SET PUBLICATION list SKIP REFRESH` with a single `SET PUBLICATION list opt_definition`. Refresh then became a WITH option, on by default.
- This change restores the two old productions. They produce the current `ALTER_SUBSCRIPTION_SET_PUBLICATION` kind, and SKIP REFRESH passes `refresh=false`.
- `WITH (refresh = ...)` without the REFRESH keyword is therefore a syntax error again. `SKIP` is not a reserved word, which is the ambiguity the fix removed.
- The C code and the enum were left alone. The current code already handles the `refresh` option in `AlterSubscription`, so only the grammar needed to regress.

## Failing oracle cases
This is the 13 of 39 that fail. I saw the tail of the oracle output and counted the 10 FAIL lines below; I did not check the full list for the other 3, including `src/test/regress||subscription`.
- src/test/subscription|t/001_rep_changes.pl: check replicated deletes after alter publication
- check replicated insert after alter publication
- check replicated inserts after subscription publication change
- check replication origin was dropped on subscriber
- check replication slot was dropped on publisher
- check replication slot was dropped on publisher#2
- check subscription relation status was dropped on subscriber
- check subscription was dropped on subscriber
- empty transaction is skipped

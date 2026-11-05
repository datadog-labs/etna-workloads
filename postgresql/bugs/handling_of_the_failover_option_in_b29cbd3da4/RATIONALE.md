# Rationale

## src/backend/commands/subscriptioncmds.c, AlterSubscription()
Traces to the fix.patch hunk in AlterSubscription that added
`PreventInTransactionBlock(isTopLevel, "ALTER SUBSCRIPTION ... SET (failover)")`
for `SET (failover)`. In current code that check lives in CheckAlterSubOption()
(only when `slot_needs_update` is true). The failover call site now passes `false`
instead of `update_failover`, so ALTER SUBSCRIPTION ... SET (failover) is again allowed
inside a transaction block even though the slot change can't be rolled back. The
slot-name-required check is skipped as well. The slot is still altered, because
update_failover stays true.

## Failing oracle cases
- src/test/regress||subscription

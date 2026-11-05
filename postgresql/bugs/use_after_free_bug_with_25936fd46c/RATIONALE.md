# Rationale

File: src/backend/commands/trigger.c, function GetAfterTriggersStoreSlot().

Traces to the fix.patch hunk that makes the storeslot get its own lifetime. In the current code that fix appears as a `CreateTupleDescCopy(tupdesc)` call, which I removed. I also removed the comment text that described the copy.

With the call gone, the storeslot, which lives in CurTransactionContext until AfterTriggerFreeQuery, uses the caller's `map->outdesc` directly. That tupdesc belongs to a ResultRelInfo's child-to-root map and can be freed first. The slot then holds a dangling tupdesc, which is a use-after-free.

Failing oracle case: src/test/regress||triggers

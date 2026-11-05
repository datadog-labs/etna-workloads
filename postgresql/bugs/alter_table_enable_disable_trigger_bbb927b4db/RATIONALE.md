# Rationale

Changed hunk: src/backend/commands/trigger.c, EnableDisableTrigger().
Traces to the fix.patch trigger.c hunk, which moved partition recursion out of the
"tgenabled changed" branch of EnableDisableTrigger. The recursion into partitions
is now done only inside `if (oldtrig->tgenabled != fires_when)`, as before the fix.
A partitioned parent whose trigger already has the requested state no longer
propagates to its partitions, whose copies may differ, so ENABLE/DISABLE TRIGGER
recursion is incomplete.

The ATPrepCmd hunk (ATSimpleRecursion) has no equivalent in current code:
recursion is driven by cmd->recurse, so it was left alone.

Failing oracle case: src/test/regress||triggers

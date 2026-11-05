# Rationale

## src/backend/commands/tablecmds.c, ATPrepCmd (AT_EnableTrig ... AT_DisableTrigUser case)
Traces to the fix.patch hunk `@@ -4777,8 +4782,9 @@ ATPrepCmd`. The fix replaced phase-1 `ATSimpleRecursion()` with
`cmd->recurse = true`, so that `EnableDisableTrigger()` recurses at execution time.
I restored the pre-fix code: for partitioned tables the command is recursed in phase 1 via
`ATSimpleRecursion()`, and `cmd->recurse` is never set. As a result the exec-time
recursion in `EnableDisableTrigger()` (trigger.c) never runs. The partitions are therefore handled
by generic child-command recursion instead of the per-trigger recursion. This is the original
bug: recursion for ENABLE/DISABLE TRIGGER is not handled correctly.

The other hunks of the fix (the `recurse` parameter plumbing, the trigger.c recursion, the
parsenodes field) are left in place. They are inert once `cmd->recurse` is never set.

## Failing oracle cases
- src/test/regress||triggers

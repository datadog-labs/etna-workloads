# Rationale
File: src/backend/commands/tablecmds.c, function tryAttachPartitionForeignKey.
Traces to the single fix_impl.patch hunk: the fix made CommandCounterIncrement() unconditional, placed before `if (queueValidation)`. I moved it back inside the `if (queueValidation)` block, as it was before the fix.
Effect: when queueValidation is false, the pg_constraint update that sets conparentid is not made visible. If the parent has two identical FK constraints, the second call can match the same partition constraint, so both get attached to it.

Failing oracle case: src/test/regress||foreign_key

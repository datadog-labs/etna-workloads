# Rationale

Both hunks are in src/backend/commands/tablecmds.c.

## 1. ATExecCmd, case AT_AddConstraint
Traces to the ATExecCmd hunk of fix_impl.patch. I removed the `cur_pass == AT_PASS_ADD_CONSTR` guard, so
ATParseTransformCmd runs on every pass again, including when a rescheduled subcommand is
executed. This is the pre-fix code. Only AT_AddConstraint exists today, because
AT_AddConstraintRecurse was folded into cmd->recurse.

## 2. ATParseTransformCmd, scheduling loop
Traces to the ATParseTransformCmd hunk of fix_impl.patch. I restored the old rules:
- A subcommand with the same subtype as the original is taken as the replacement and executed
  immediately in the current pass. It is never rescheduled.
- Other subcommands go through the switch, and an unexpected subtype is an error.
- The scheduled pass must be later than cur_pass, otherwise "ALTER TABLE scheduling failure".

The fix delayed a transformed AT_AddConstraint into a later pass in all cases. Without that, a
foreign key added in the same ALTER TABLE as the pkey or unique constraint it depends on runs
before that constraint exists, and fails (bug #16589). Current-code differences, such as the
CONSTR_NOTNULL case, are kept.

## Failing oracle cases
- src/test/regress||alter_table

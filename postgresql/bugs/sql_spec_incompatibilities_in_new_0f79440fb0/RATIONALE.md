# Rationale

Hunk: src/backend/commands/trigger.c, CreateTrigger() — removed the check
`if (stmt->columns != NIL) ereport(ERROR, "transition tables cannot be specified for triggers with column lists")`.
Traces to the fix.patch trigger.c hunk that added this check ("forbid using transition tables with column-specific UPDATE triggers"). Without it, such triggers are accepted again, as before the fix.

Failing oracle case: src/test/regress||triggers (expects the error).

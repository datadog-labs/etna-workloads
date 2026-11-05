# Rationale

File: src/backend/parser/parse_utilcmd.c, function transformColumnDefinition, case CONSTR_IDENTITY.

Traces to the fix.patch hunk that added the "conflicting NULL/NOT NULL declarations" error when an identity
constraint follows an explicit NULL (`saw_nullable && !column->is_not_null`). In current code that check is
the `else if (!column->is_not_null) ereport(...)` branch after `if (!saw_nullable) need_notnull = true;`.
I removed that branch. So `col int NULL GENERATED ... AS IDENTITY` is no longer rejected, and the column
ends up nullable (is_not_null stays false, need_notnull is not set).

Failing oracle case: src/test/regress||identity

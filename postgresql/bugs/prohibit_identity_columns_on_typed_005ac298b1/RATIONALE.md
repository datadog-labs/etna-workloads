# Rationale
File: src/backend/parser/parse_utilcmd.c, function transformColumnDefinition, case CONSTR_IDENTITY.
Traces to the fix.patch hunk adding the `cxt->ofType` / `cxt->partbound` ereport(ERROR) checks there.
Removed both checks, so identity columns are again accepted on typed tables (CREATE TABLE ... OF type) and partitions. The ofType/partbound context fields remain since they are used elsewhere now.

Failing oracle case: src/test/regress||identity

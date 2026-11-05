# Rationale

- File/function: src/backend/commands/tablecmds.c, ATPrepAddPrimaryKey.
- Traces to the fix.patch hunk that added the early "No work if not creating a primary key" return. In today's code the check is `pkconstr->contype != CONSTR_PRIMARY`. I removed it.
- Effect: ADD CONSTRAINT commands that are not primary keys (UNIQUE, CHECK, etc.) now go through the PK not-null logic. Columns of a UNIQUE constraint are wrongly made NOT NULL, or a non-PK constraint is processed as if it were a PK.

Oracle case expected to fail: src/test/regress||inherit

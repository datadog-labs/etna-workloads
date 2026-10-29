# Rationale

Fix: `sqlite3AlterBeginAddColumn()` gained `sqlite3MayAbort(pParse)` so that ALTER TABLE ADD COLUMN
(which runs OP_ParseSchema) opens a statement journal when the transaction has written to virtual tables.

In 3.54.1 the same requirement is covered by three paths, so all had to be reverted:
- `src/alter.c` sqlite3AlterBeginAddColumn: removed `sqlite3MayAbort(pParse)` (the fix hunk, reversed directly).
- `src/vdbeaux.c` sqlite3VdbeAddParseSchemaOp: the unconditional `sqlite3MayAbort()` is now only done when
  `zWhere==0`. Pre-fix, only OP_ParseSchema with p4.z==0 was considered a may-abort op, so ParseSchema
  with a WHERE clause (the ADD COLUMN / CREATE TABLE case) did not set mayAbort. (Corresponds to the
  vdbeaux.c hunk of the fix; the assert helper sqlite3VdbeAssertMayAbort still treats all
  OP_ParseSchema as aborting, as modern code does.)
- The OP_Function path (sqlite3MayAbort in sqlite3VdbeAddFunctionCall) was left alone.

Result: sqlite3FinishCoding's assertion `!isMultiWrite || sqlite3VdbeAssertMayAbort(v, mayAbort)` fails
for statements whose ParseSchema carries a WHERE (starting with fts5misc-1.0's CREATE VIRTUAL TABLE),
so the oracle run aborts: all 116 oracle cases are reported failing (incomplete run, assert).

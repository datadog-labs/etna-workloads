# Rationale

Bug: DROP TABLE on a virtual table did not call sqlite3MayAbort(), so no statement
journal was opened. If xDestroy() failed, the statement could not be rolled back and
the sqlite_master row was removed anyway.

Changes (each reverses one hunk of fix.patch; the code is the same as pre-fix):
- src/build.c, sqlite3CodeDropTable(): removed `sqlite3MayAbort(pParse)` after OP_VDestroy.
- src/vdbe.c, OP_VDestroy: removed `assert( p->errorAction==OE_Abort && p->usesStmtJournal )`.
- src/vdbeaux.c, sqlite3VdbeAssertMayAbort(): removed `opcode==OP_VDestroy` from the opcode list.

Oracle failures (test/vtabdrop.test): vtabdrop-1.2, 1.3, 2.2, 2.3. After the failed DROP TABLE,
sqlite_master has lost the virtual table's own row (rt / ft), while its shadow tables remain.

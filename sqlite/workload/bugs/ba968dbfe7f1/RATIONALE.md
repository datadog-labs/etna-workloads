# Rationale

Fix: CREATE INDEX emitted `OP_Expire P1=0 P2=1` (advisory expiry, running statements finish).
Pre-fix code emitted `OP_Expire` with no P2, i.e. immediate expiry.

Changed hunk (src/build.c, sqlite3CreateIndex): `sqlite3VdbeAddOp2(v, OP_Expire, 0, 1)` -> `sqlite3VdbeAddOp0(v, OP_Expire)`.
This reverses the fix's build.c hunk. With P2=0, sqlite3ExpirePreparedStatements(db,0) sets expired=1, and the
`p->expired==1` check in OP_OpenRead/OP_OpenWrite (vdbe.c) aborts the running SELECT. The other fix hunks (the P2 plumbing) are
left in place; they're harmless without a caller using P2=1.

Oracle: tkt-c694113d5.100 fails with "abort due to ROLLBACK" (the SELECT loop is aborted when CREATE INDEX runs mid-query).

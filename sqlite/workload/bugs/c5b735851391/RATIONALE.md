# Rationale

Fix: dan, 2015-05-26. It moved the "skip PRIMARY KEY btree" Noop/Goto from
sqlite3AddPrimaryKey (a Noop emitted before every PK index) to a Noop emitted
inside sqlite3CreateIndex and stored in Index.tnum. That way the Goto lands on
the index that actually became the PK, even when the PK constraint was merged
into an earlier redundant UNIQUE index.

Reverted (all in tree/):
- src/sqliteInt.h: re-added `Parse.u1.cr.addrSkipPK`. The fix removed `addrSkipPK`;
  it now lives in the `cr` union because that is where the CREATE TABLE fields are.
- src/build.c `sqlite3AddPrimaryKey`: emit `OP_Noop` and record it in addrSkipPK
  before `sqlite3CreateIndex`, and `JumpHere` after it. This reverses the fix's
  first hunk.
- src/build.c `sqlite3CreateIndex`: removed the Noop stored in `pIndex->tnum` and
  the trailing `JumpHere`. This reverses the third hunk.
- src/build.c `convertToWithoutRowidTable`: the Goto patch is back at
  `addrSkipPK`, before the PK is located, instead of at `pPk->tnum` after it.
  This reverses the second hunk. It also removes the later
  `if( v && pPk->tnum>0 )` block that did the same thing in 3.54.1.

Effect: when the PK duplicates an earlier UNIQUE constraint, e.g.
`b UNIQUE PRIMARY KEY`, the Noop at addrSkipPK has no code after it. The
Goto therefore skips nothing, and the earlier UNIQUE index (now the PK) still gets
a btree and an sqlite_schema row.

Oracle: without_rowid1-6.0 aborts with
`Assertion pPk->tnum==pTab->tnum || CORRUPT_DB failed` in sqlite3OpenTable.
Run `./check.sh` for the full list. Case 6.1 was not reached because the assert
aborted the run.

# Rationale

Changed only `tree/src/update.c` (in sqlite3Update, just before the OP_Delete/OP_Insert).

The fix replaced the pre-existing ticket-ec8abb025e78f40c workaround with an
`OP_FinishSeek` emitted when `bFinishSeek` is set. In 3.54.1 that is the block
`if( bFinishSeek ){ sqlite3VdbeAddOp1(v, OP_FinishSeek, iDataCur); }`. I removed
it and restored the pre-fix code: a bogus `OP_Column` (OPFLAG_TYPEOFARG),
emitted only when `eOnePass!=ONEPASS_OFF` and the table has virtual columns.
This is the same code the fix's `-` hunk deleted. The OP_FinishSeek opcode,
`bFinishSeek` computation and `sqlite3WhereUsesDeferredSeek()` are left in place
(unused by UPDATE, still used by DELETE), so the build is unaffected.

The effect is that an UPDATE on a non-virtual-column table can reach OP_Delete/
OP_Insert after an OP_DeferredSeek with no intervening OP_Column.

## Oracle failure
`test/update.test` update-19.10 (`UPDATE t1 SET a=quote(b) WHERE b>=2` on a
table with INTEGER PRIMARY KEY UNIQUE) aborts with
`Assertion 'pC->deferredMoveto==0' failed` in OP_Insert. This is the assertion
fault reported by Yongheng that the fix addressed.

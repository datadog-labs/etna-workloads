# Rationale

Changed `tree/src/insert.c` (sqlite3Insert, ~line 1070): `bIdListInOrder` is
computed as `(pTab->tabFlags & TF_HasStored)==0` instead of
`(pTab->tabFlags & (TF_OOOHidden|TF_HasStored))==0`.

This reverses the fix hunk `bIdListInOrder = (pTab->tabFlags & TF_OOOHidden)==0;`
(in the original, the flag was initialised to 1 and so ignored out-of-order
hidden columns). The TF_OOOHidden flag is still set in vtab.c, but INSERT no longer
consults it, so INSERT ... SELECT / multi-row VALUES into a virtual table with a
hidden column followed by non-hidden columns skips the column shuffle.
(The TF_HasStored term is unrelated and left intact.)

Oracle: test/vtabA.test fails from vtabA-1.7 (INSERT INTO t1e SELECT 'abc','def')
with assertion `memIsValid(pX)` in sqlite3VdbeExec; the remaining cases don't
run because of the crash.

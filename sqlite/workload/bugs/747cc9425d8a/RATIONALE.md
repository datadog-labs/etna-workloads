# Rationale

## Hunk reversed

`src/alter.c`, `dropColumnFunc()`.

Fix hunk:
```
-  if( pTab->nCol==1 || iCol>=pTab->nCol ){
+  if( pTab==0 || pTab->nCol==1 || iCol>=pTab->nCol ){
```

The fix added a `pTab==0 ||` guard before dereferencing `pTab` in the
corrupt-schema check inside `dropColumnFunc()`. I removed that guard again in
`tree/src/alter.c`, restoring:

```c
pTab = sParse.pNewTable;
if( pTab->nCol==1 || iCol>=pTab->nCol ){
```

This is the exact logic the fix removed: `sParse.pNewTable` (aliased to
`pTab`) can be left NULL by `renameParseSql()` when it successfully parses a
`sqlite_schema.sql` string that does not actually produce a table definition
for the target object — e.g. the row for the table being altered has been
overwritten (via `writable_schema`) with the SQL for a CREATE INDEX or a
CREATE VIEW with a different shape. In that case `sParse.pNewTable` stays 0
after `renameParseSql()` returns `SQLITE_OK`, and dereferencing
`pTab->nCol` crashes with a NULL pointer dereference instead of being caught
as `SQLITE_CORRUPT_BKPT`.

This is a one-line revert of the single hunk the fix made to non-test code;
no other path in version-3.54.1 independently guards against this same NULL
dereference in `dropColumnFunc()`, so no second location needed reverting.

## Oracle result

Running `./check.sh`, the test file hangs/aborts at `alterdropcol-6.0` (the
first of the two new regression cases added by the fix) with no further
output — i.e. the process dies (SIGSEGV from the NULL dereference) instead of
reporting the expected `{1 {database disk image is malformed}}` result. This
matches the oracle: both `alterdropcol-6.0` (schema row for `t2` overwritten
with a `CREATE INDEX` statement) and `alterdropcol-6.1` (schema row for `t2`
overwritten with a `CREATE VIEW` statement) are designed to exercise exactly
this `pTab==0` case in `dropColumnFunc()`, and the crash on 6.0 confirms the
bug is reintroduced.

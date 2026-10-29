# Rationale

## src/vtab.c, sqlite3VtabEponymousTableInit()
Reverses the fix hunk that removed `return 0;` after
`sqlite3VtabEponymousTableClear()` in the `if( rc )` branch. The fix made the
function return non-zero when xConnect failed with an error left in pParse.
Re-adding `return 0` restores the old behaviour: sqlite3LocateTable() then
treats the module as having no eponymous table, falls through, and reports
"no such table", clobbering the xConnect error message.

The other fix hunks only touch a comment and a `testcase()` in build.c, so no
change is needed there. 3.54.1 also sets `pParse->rc = rc` here, but that does
not restore the message.

## Oracle failure
bestindex1-5.0: expected `1 {wrong number of arguments}`, got
`1 {no such table: tcl}`.

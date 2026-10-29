# Rationale

## Change: src/insert.c (sqlite3Insert, upsert target analysis loop)
Reverses the fix's only implementation hunk. The fix made the loop check the
return value of `sqlite3UpsertAnalyzeTarget()` and `goto insert_cleanup` on
error. In 3.54.1 the call has an extra `pUpsert` argument, but the check is the
same. I removed the check, so the call is now a bare statement. This is the
pre-fix code. After a failed name resolution in one ON CONFLICT clause, the
loop carries on to the next clause and later code runs on a half-resolved
parse tree.

## Oracle failure
`upsert5-2.1` (two ON CONFLICT clauses, the second with
`(SELECT t2 FROM nosuchtable)`) aborts with
`lookupName: Assertion 'pTab!=0 && pTab->zName!=0' failed`. The fixed build
returns `1 {no such table: nosuchtable}`. The other upsert5 cases still pass.

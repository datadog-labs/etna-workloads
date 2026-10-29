# Rationale

The fix (resolve.c hunks) guards against a NULL `zEName` (as produced by the
VALUES component of a compound SELECT) before comparing names in
`lookupName()` and `resolveAsName()`. In 3.54.1 the guard is `sqlite3_stricmp`
(NULL-safe), so the bug was masked. I changed it back to the unguarded
`sqlite3StrICmp` in both places:

- `lookupName()` (src/resolve.c ~667): `sqlite3_stricmp(zAs,zCol)` -> `sqlite3StrICmp(zAs,zCol)`
- `resolveAsName()` (src/resolve.c ~1535): likewise for `pEList->a[i].zEName`.

Both are the unguarded name comparison the fix replaced; a NULL `zEName` is dereferenced.

Failing oracle case: orderby1-11.0 (`VALUES(2) EXCEPT SELECT '' ORDER BY abc`)
crashes the test process (NULL deref, segfault) instead of returning the
"1st ORDER BY term does not match any column" error. Earlier cases pass.

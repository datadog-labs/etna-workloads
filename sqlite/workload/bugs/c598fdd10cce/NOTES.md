repro.sh creates an fts5 table using the `ascii` tokenizer, then (with
writable_schema/defensive off) rewrites the stored CREATE VIRTUAL TABLE sql
to reference a nonexistent tokenizer `blah`. It closes and reopens the
database, then runs `SELECT highlight(t1, 0, '[', ']') FROM t1`, which
forces fts5 to recreate its config and hit the "no such tokenizer" error
path (fts5GetTokenizer / sqlite3Fts5ConfigErrmsg).

- clean shell: reports `Error near line 1: SQL logic error` and exits 0.
- buggy shell: segfaults (exit 139), because the injected bug writes the
  error message through an uninitialized/unset `pConfig->pzErrmsg` pointer
  instead of guarding it, corresponding to the fix in fix.patch
  (`if( pzErr ) *pzErr = ...` / passing the real pzErrmsg properly).

This covers the fts5aux-13.4 case from the test's added block; the other
listed fts5aux-15.x cases exercise the same underlying tokenizer-lookup code
path via different queries (aux functions/instance iteration) and share the
same bug, so this single repro demonstrates the regression.

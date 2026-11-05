# Reintroduced bug: SIMILAR TO strictness

The fix added strict `similar_to_escape` functions so that `ESCAPE NULL` returns NULL. This change makes the parser use the non-strict legacy `similar_escape` again. In that function a NULL escape means "use the default backslash".

Changes:
- `src/backend/parser/gram.y`, the four `SIMILAR TO` / `NOT SIMILAR TO` rules in `a_expr`. They trace to the gram.y hunks in fix.patch. They call `similar_escape` instead of `similar_to_escape`. The no-ESCAPE forms pass `list_make2(pat, makeNullAConst(-1))` instead of `list_make1(pat)`. `x SIMILAR TO y ESCAPE NULL` therefore matches with the default escape, not NULL as the spec requires.
- `src/backend/catalog/system_functions.sql`, `substring(text,text,text)`. It traces to the pg_proc.dat hunk that changed the `substring` body from `similar_escape` to `similar_to_escape`. The body is now `similar_escape` again, so `substring(... FOR NULL)` is non-strict again.

The `similar_to_escape` catalog entries and the C functions in regexp.c are left in place. They are unused now.

Failing oracle case: `src/test/regress||strings`.

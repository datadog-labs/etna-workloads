# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b0f5d25bc3679afaed69d367c72efd387c763d04 ("Code coverage for most pg_mblen* calls."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/arrayfuncs.c

Failing oracle cases:
- `src/test/regress||encoding`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0eaaaf00e296c2048b868b7c1d3c12c0eae6dd12 ("Prevent crash when ts_rewrite() replaces a non-top-level subtree with null."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/tsquery_rewrite.c

Failing oracle cases:
- `src/test/regress||tsearch`

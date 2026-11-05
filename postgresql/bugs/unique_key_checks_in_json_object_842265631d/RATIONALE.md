# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 842265631dfd9e5583d934e2ae328b09bc4b2f8b ("Fix unique key checks in JSON object constructors"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/json.c

Failing oracle cases:
- `src/test/regress||json`
- `src/test/regress||sqljson`

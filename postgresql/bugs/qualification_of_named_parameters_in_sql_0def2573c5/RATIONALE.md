# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0def2573c5f0ff127d0c7dc12ec7da56ae6fb7fe ("Fix *-qualification of named parameters in SQL-language functions."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/functions.c

Failing oracle cases:
- `src/test/regress||rowtypes`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 33e729c5148c3a697abc552621b34bdc5fd497ed ("Fix EXPLAIN output for subplans in MERGE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/ruleutils.c

Failing oracle cases:
- `src/test/regress||merge`

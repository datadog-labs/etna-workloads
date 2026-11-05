# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cfc43aeb3810ebaa8dbda4807046a4c953d9e992 ("Fix marking of indisvalid for partitioned indexes at creation"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/indexcmds.c

Failing oracle cases:
- `src/test/regress||indexing`

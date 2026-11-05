# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 12e423e21d8ef47d95a099c12f625f6d191eaf92 ("Fix EXPLAIN MERGE output when no tuples are processed"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/explain.c

Failing oracle cases:
- `src/test/regress||merge`

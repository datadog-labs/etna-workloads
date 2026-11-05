# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6298a41b4e34773dbc0c50c26de825a4efe31f07 ("Fix missing money overflow checks for INT64_MIN / -1"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/cash.c

Failing oracle cases:
- `src/test/regress||money`

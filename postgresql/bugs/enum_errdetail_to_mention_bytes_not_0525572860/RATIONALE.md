# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0525572860335d050a1bea194a5278c8833304d1 ("Fix enum errdetail to mention bytes, not chars"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/catalog/pg_enum.c

Failing oracle cases:
- `src/test/regress||enum`

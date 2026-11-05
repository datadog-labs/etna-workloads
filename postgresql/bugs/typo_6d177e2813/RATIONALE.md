# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6d177e2813a2b4415539e2861b595583cc1a8f71 ("Fix typo"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/parser/parse_cte.c

Failing oracle cases:
- `src/test/regress||with`

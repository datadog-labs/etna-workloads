# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d0bb49e61168953f0f07c3beeb2b8fb63a3521a2 ("Fix LIKE/regex optimization for indexscan with exact-match pattern."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/like_support.c

Failing oracle cases:
- `src/test/regress||collate`
- `src/test/regress||collate.icu.utf8`

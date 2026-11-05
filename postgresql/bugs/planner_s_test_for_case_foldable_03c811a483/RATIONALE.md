# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 03c811a483b243952874d8e2b3f0c2e3793bc952 ("Fix planner's test for case-foldable characters in ILIKE with ICU."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/like_support.c

Failing oracle cases:
- `src/test/regress||collate.icu.utf8`

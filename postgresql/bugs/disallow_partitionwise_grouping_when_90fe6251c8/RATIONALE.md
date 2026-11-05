# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 90fe6251c816547b9cb4e1895dd8e6620bae94e1 ("Disallow partitionwise grouping when collations don't match"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/planner.c

Failing oracle cases:
- `src/test/regress||collate.icu.utf8`

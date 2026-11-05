# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9626068f13338f79ba183b4cf3c975e22c98c575 ("Avoid unnecessary post-sort projection"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/planner.c

Failing oracle cases:
- `src/test/regress||select_distinct_on`

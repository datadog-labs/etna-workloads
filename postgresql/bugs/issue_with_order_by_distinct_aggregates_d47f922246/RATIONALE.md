# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d47f922246b54f0290811951e0b73a3d6110437c ("Fix issue with ORDER BY / DISTINCT aggregates and FILTER"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/planner.c

Failing oracle cases:
- `src/test/regress||aggregates`
- `src/test/regress||sqljson`

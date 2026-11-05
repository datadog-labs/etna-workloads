# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4d5f651f1d651c6fa79f9188e7b9a04654c7125a ("Fix planner error with pulling up subquery expressions into function RTEs."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/planner.c

Failing oracle cases:
- `src/test/regress||rangefuncs`

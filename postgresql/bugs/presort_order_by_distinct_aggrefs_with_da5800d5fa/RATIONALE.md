# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit da5800d5fa636c6e10c9c98402d872c76aa1c8d0 ("Don't presort ORDER BY/DISTINCT Aggrefs with volatile functions"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/planner.c

Failing oracle cases:
- `src/test/regress||aggregates`

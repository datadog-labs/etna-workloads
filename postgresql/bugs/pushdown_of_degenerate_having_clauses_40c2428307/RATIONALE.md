# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 40c2428307b82d590f0caf73c93a5cdaf721e8b8 ("Fix pushdown of degenerate HAVING clauses"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/planner.c

Failing oracle cases:
- `src/test/regress||groupingsets`

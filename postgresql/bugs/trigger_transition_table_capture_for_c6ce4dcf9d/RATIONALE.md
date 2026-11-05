# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c6ce4dcf9d3b7a8a89aca386124c473f98fc329e ("Fix trigger transition table capture for MERGE in CTE queries."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c, src/include/commands/trigger.h

Failing oracle cases:
- `src/test/regress||triggers`

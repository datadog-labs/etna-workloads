# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c6f28af5d7af87d7370e5f169251d91437f100a2 ("Avoid generating bogus paths with partitionwise aggregate."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/planner.c

Failing oracle cases:
- `src/test/regress||partition_aggregate`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 326a33a289c7ba2dbf45f17e610b7be98dc11f67 ("Fix corner-case planner failure for MERGE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/appendinfo.c

Failing oracle cases:
- `src/test/regress||merge`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 691836405f1ecae2368a0f2fdbfee3b2cb53375b ("Fix parse_cte.c's failure to examine sub-WITHs in DML statements."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_cte.c

Failing oracle cases:
- `src/test/regress||with`

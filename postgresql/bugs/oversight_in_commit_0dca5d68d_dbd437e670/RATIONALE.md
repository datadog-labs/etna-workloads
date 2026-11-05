# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit dbd437e670b88ca67f6b2477e853412a0e82a8cc ("Fix oversight in commit 0dca5d68d."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/functions.c

Failing oracle cases:
- `src/test/regress||create_function_sql`

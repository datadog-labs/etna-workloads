# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 906b68217a1e756a49acd0864773680d1eb8a10d ("Fix re-execution of a failed SQLFunctionCache entry."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/functions.c

Failing oracle cases:
- `src/test/regress||create_function_sql`

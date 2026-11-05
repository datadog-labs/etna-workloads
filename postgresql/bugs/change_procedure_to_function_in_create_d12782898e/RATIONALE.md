# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d12782898eb5979bef3c6dd0d80b93d1aaf53cac ("Change PROCEDURE to FUNCTION in CREATE OPERATOR syntax"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/operatorcmds.c, src/bin/pg_dump/pg_dump.c

Failing oracle cases:
- `src/test/regress||create_operator`

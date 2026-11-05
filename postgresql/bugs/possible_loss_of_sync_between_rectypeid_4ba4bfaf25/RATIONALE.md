# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4ba4bfaf256c17fe4c8f497924b74eb98241b84f ("Fix possible loss of sync between rectypeid and underlying PLpgSQL_type."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpgsql/src/pl_exec.c

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_record`

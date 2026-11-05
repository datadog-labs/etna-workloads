# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ce4b7e3a1058eb3edd7511f2770379d7f78bd3a0 ("Fix plpgsql's handling of "return simple_record_variable"."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpgsql/src/pl_exec.c

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_domain`

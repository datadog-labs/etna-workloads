# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4af123ad45bd5e91221983da1152033e6153498c ("Fix misleading error message context"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/spi.c

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_record`
- `src/pl/plpgsql/src||plpgsql_varprops`
- `src/test/regress||plpgsql`

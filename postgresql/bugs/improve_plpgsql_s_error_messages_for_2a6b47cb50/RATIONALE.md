# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2a6b47cb50eb9b62b050de2cddd03a9ac267e61f ("Improve plpgsql's error messages for incorrect %TYPE and %ROWTYPE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpgsql/src/pl_comp.c, src/pl/plpgsql/src/pl_gram.y

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_misc`

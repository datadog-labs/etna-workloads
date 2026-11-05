# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2edb9491155ad70e57b5d18f2aa0d8d5a09386cd ("Fix a few bogus statement type names in plpgsql error messages."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/plpgsql/src/pl_funcs.c

Failing oracle cases:
- `src/test/regress||event_trigger`
- `src/test/regress||plpgsql`
- `src/test/regress||triggers`

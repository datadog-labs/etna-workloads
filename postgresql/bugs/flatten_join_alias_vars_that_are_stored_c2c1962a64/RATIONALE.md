# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c2c1962a64b547412c88fa2728e4fa35e65f4c90 ("Don't flatten join alias Vars that are stored within a GROUP RTE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_agg.c

Failing oracle cases:
- `src/test/regress||aggregates`

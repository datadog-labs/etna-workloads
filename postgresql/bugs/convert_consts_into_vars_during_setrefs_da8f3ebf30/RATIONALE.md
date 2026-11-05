# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit da8f3ebf30bef9c950595dc0d1f03bce2b1b8563 ("Don't convert Consts into Vars during setrefs.c processing."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/setrefs.c

Failing oracle cases:
- `src/test/regress||inherit`

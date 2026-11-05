# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit eae0e20deffb0a73f7cb0e94746f94a1347e71b1 ("Remove over-optimistic Assert."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/setrefs.c

Failing oracle cases:
- `src/test/regress||join`

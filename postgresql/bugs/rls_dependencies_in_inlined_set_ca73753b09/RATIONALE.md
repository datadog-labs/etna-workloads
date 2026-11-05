# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ca73753b090c33bc69ce299b4d7fff891a77b8ad ("Handle RLS dependencies in inlined set-returning functions properly."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/clauses.c

Failing oracle cases:
- `src/test/regress||rowsecurity`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit dc8d72c1c213d65a3f1500111d3c773aabce419f ("Collect dependency information for parsed CallStmts."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/plan/setrefs.c

Failing oracle cases:
- `src/pl/plpgsql/src||plpgsql_call`

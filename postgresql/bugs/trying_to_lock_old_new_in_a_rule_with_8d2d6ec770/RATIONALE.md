# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8d2d6ec7708b475787fd92a9f828e554805e3df6 ("Avoid trying to lock OLD/NEW in a rule with FOR UPDATE."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/parser/analyze.c, src/include/nodes/parsenodes.h

Failing oracle cases:
- `src/test/regress||rules`

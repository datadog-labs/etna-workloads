# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 35d9a6263407563f9948a38fced5419deab297a2 ("IS JSON/JSON(): Protect against expressions uncoercible to text"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/nodes/makefuncs.c, src/backend/parser/parse_expr.c

Failing oracle cases:
- `src/test/regress||sqljson`

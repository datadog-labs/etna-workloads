# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 336ea6e6ff1109e7b83370565e3cb211804fda0c ("Fix bugs in polymorphic-argument resolution for multiranges."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_coerce.c

Failing oracle cases:
- `src/test/regress||polymorphism`
- `src/test/regress||rangefuncs`

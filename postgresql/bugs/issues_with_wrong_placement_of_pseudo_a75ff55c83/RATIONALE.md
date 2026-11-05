# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a75ff55c83342656266deb1890bcdd27466333ea ("Fix some issues with wrong placement of pseudo-constant quals."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/equivclass.c, src/backend/optimizer/plan/initsplan.c

Failing oracle cases:
- `src/test/regress||join`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cc5d98525d43c22b98f360ef0f2c8d7dc57f04dc ("Fix incorrect handling of subquery pullup"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/prep/prepjointree.c, src/backend/rewrite/rewriteManip.c

Failing oracle cases:
- `src/test/regress||groupingsets`

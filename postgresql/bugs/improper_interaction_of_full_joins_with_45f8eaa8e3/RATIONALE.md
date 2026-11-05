# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 45f8eaa8e3031c9cb12deb1b5e294bc052b378f2 ("Fix improper interaction of FULL JOINs with lateral references."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/joinrels.c

Failing oracle cases:
- `src/test/regress||rangefuncs`

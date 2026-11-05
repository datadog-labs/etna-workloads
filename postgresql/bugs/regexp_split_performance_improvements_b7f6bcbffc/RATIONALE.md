# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b7f6bcbffcc0b41d783c0c9c61766428159969ff ("Repair bug in regexp split performance improvements."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/regexp.c

Failing oracle cases:
- `src/test/regress||strings`

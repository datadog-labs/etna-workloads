# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a43b4ab1111ca5e5f40a2ddd8e56bf999b9fdad9 ("Fix enforcement of restrictions inside regexp lookaround constraints."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/regex/regcomp.c

Failing oracle cases:
- `src/test/regress||regex`

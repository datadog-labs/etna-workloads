# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8a29ed05302ea18b4be177c2d1181b43706af45f ("Fix misoptimization of "{1,1}" quantifiers in regular expressions."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/regex/regcomp.c

Failing oracle cases:
- `src/test/regress||regex`

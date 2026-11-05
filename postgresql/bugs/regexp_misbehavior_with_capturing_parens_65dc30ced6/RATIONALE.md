# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 65dc30ced64cd17f3800ff1b73ab1d358e92efd8 ("Fix regexp misbehavior with capturing parens inside "{0}"."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/regex/regcomp.c

Failing oracle cases:
- `src/test/modules/test_regex||test_regex`
- `src/test/regress||regex`

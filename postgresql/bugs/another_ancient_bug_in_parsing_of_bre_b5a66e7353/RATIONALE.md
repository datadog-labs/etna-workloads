# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b5a66e7353ba65c11c5fc6a79b72213bde8dbe44 ("Fix another ancient bug in parsing of BRE-mode regular expressions."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/regex/regc_lex.c

Failing oracle cases:
- `src/test/modules/test_regex||test_regex`

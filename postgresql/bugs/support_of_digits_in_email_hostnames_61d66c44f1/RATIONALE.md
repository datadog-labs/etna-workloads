# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 61d66c44f18c73094a50a2ef97d26cc03e171dc0 ("Fix support of digits in email/hostnames."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/tsearch/wparser_def.c

Failing oracle cases:
- `src/test/regress||tsearch`

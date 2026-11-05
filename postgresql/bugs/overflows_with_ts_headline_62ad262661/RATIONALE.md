# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 62ad262661ed92b0fbd43e8b7bbd1e0e38cbb9c0 ("Fix overflows with ts_headline()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/tsearch/wparser_def.c

Failing oracle cases:
- `src/test/regress||tsearch`

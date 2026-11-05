# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2604438472c897fbbd1568b1a8ee177ba8cdb6e3 ("Fix handling of phrase operator removal while removing tsquery stopwords."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/tsquery_cleanup.c

Failing oracle cases:
- `src/test/regress||tsearch`

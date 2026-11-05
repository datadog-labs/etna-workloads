# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5603e119f4bd4818f8fa432ffc177c3caf9efeb6 ("Fix incorrect punctuation in error message"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/timestamp.c

Failing oracle cases:
- `src/test/regress||window`

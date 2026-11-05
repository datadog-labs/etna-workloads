# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 13e20d1c9d99516d13f3ee0dc164168a74cde0df ("Fix estimate_array_length error with set-operation array coercions"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/selfuncs.c

Failing oracle cases:
- `src/test/regress||union`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0c4f355c6a5fd437f71349f2f3d5d491382572b7 ("Fix parsing of complex morphs to tsquery"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/tsearch/to_tsany.c

Failing oracle cases:
- `src/test/regress||tsearch`

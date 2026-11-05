# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f4e7ae2b8a67ad6801726553a024a3306716ef80 ("Fix SP-GiST scan initialization logic for binary-compatible cases."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/access/spgist/spgutils.c

Failing oracle cases:
- `src/test/regress||spgist`

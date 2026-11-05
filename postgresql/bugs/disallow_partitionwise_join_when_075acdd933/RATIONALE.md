# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 075acdd93388c080c0fb0aca5723144ad7a56dac ("Disallow partitionwise join when collations don't match"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/util/relnode.c

Failing oracle cases:
- `src/test/regress||collate.icu.utf8`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c39392ebaeeff7dafbc255844bcc605aaef01d7d ("Fix freeing a child join's SpecialJoinInfo"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/joinrels.c

Failing oracle cases:
- `src/test/regress||partition_join`

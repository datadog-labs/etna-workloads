# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 21378e1fefedcaed3d855ae7aa772555295d05d6 ("Fix ALTER DEFAULT PRIVILEGES with duplicated objects"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/aclchk.c

Failing oracle cases:
- `src/test/regress||privileges`

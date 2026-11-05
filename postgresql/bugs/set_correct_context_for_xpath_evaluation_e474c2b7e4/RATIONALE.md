# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e474c2b7e4b656895d6afcbd36857c9ebb0fcedd ("Set correct context for XPath evaluation"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/xml.c

Failing oracle cases:
- `src/test/regress||xml`

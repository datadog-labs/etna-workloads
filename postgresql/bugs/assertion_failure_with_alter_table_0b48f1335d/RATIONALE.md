# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0b48f1335dddb7141160e392cccac98edfb3fa85 ("Fix assertion failure with ALTER TABLE ATTACH PARTITION and indexes"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_utilcmd.c

Failing oracle cases:
- `src/test/regress||indexing`

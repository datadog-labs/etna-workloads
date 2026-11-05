# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6029861916e8e2c0155c332c10f182a22619c663 ("Fix DDL deparse of CREATE OPERATOR CLASS"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/opclasscmds.c, src/backend/tcop/utility.c

Failing oracle cases:
- `src/test/modules/test_ddl_deparse||opfamily`
- `src/test/regress||event_trigger`

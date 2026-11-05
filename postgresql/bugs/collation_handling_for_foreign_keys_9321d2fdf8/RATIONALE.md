# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9321d2fdf808e93095c4f86565dc8c8178675841 ("Fix collation handling for foreign keys"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c, src/backend/utils/adt/ri_triggers.c

Failing oracle cases:
- `src/test/regress||collate.icu.utf8`

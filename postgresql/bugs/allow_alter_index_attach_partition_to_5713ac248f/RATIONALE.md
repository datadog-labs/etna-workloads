# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5713ac248f266c689d93999aacd318d9f7f9daec ("Allow ALTER INDEX .. ATTACH PARTITION to validate a parent index"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||indexing`

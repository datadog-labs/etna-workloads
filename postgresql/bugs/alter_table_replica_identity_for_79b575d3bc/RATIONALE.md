# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 79b575d3bc09cc67a7b5c2da454aeb35f4beccc5 ("Fix ALTER TABLE / REPLICA IDENTITY for temporal tables"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||without_overlaps`

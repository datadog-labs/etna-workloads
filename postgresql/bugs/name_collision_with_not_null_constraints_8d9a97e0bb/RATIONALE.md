# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8d9a97e0bb6d820dac553848f0d5d8cc3f3e219d ("Avoid name collision with NOT NULL constraints"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/catalog/heap.c, src/backend/commands/tablecmds.c, src/include/catalog/heap.h

Failing oracle cases:
- `src/test/regress||create_table`

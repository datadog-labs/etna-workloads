# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 83917791385a601bfe8afe95f250cb2ae6c1fde7 ("Fix ALTER TABLE DETACH for inconsistent indexes"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||constraints`

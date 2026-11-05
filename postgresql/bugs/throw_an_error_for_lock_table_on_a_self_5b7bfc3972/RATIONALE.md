# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5b7bfc39726ff9f6c52dd73e337c34e74e0d1f39 ("Don't throw an error for LOCK TABLE on a self-referential view."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/lockcmds.c

Failing oracle cases:
- `src/test/regress||lock`

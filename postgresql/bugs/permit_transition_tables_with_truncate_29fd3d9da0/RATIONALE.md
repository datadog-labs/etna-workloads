# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 29fd3d9da0ff9e230ff051c1423871bd6eac377d ("Don't permit transition tables with TRUNCATE triggers."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c

Failing oracle cases:
- `src/test/regress||plpgsql`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e6d0d16adf7fb7e715314d5068db4b875c3edf00 ("Don't throw an error if a queued AFTER trigger no longer exists."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c

Failing oracle cases:
- `src/test/regress||triggers`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d479d00285255d422a2b38f1cfaa35808968a08c ("Don't crash on reference to an un-available system column."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/execTuples.c

Failing oracle cases:
- `src/test/regress||update`

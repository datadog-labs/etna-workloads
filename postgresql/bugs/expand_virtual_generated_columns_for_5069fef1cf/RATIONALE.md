# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5069fef1cfae271ca62e254b16dc831145bc5a4f ("Expand virtual generated columns for ALTER COLUMN TYPE"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||generated_virtual`

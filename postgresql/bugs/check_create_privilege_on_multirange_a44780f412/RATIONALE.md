# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a44780f412515f70c3f155db04df13af67cea74c ("Check CREATE privilege on multirange type schema in CREATE TYPE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/typecmds.c

Failing oracle cases:
- `src/test/regress||multirangetypes`

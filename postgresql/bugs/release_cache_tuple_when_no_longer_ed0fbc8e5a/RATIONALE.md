# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ed0fbc8e5ac995eada933250c1d5535336442b97 ("Release cache tuple when no longer needed"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/publicationcmds.c

Failing oracle cases:
- `src/test/regress||publication`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6f5c8a8ec23f8ab00da4d2b77bfc8af2a578c4d3 ("Remove bogus restriction from BEFORE UPDATE triggers"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c

Failing oracle cases:
- `src/test/regress||triggers`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c426f7c2b36a5efd9bcef2a2dfcc559f7879cd84 ("Fix assertion failure with REINDEX and event triggers"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/indexcmds.c

Failing oracle cases:
- `src/test/regress||event_trigger`

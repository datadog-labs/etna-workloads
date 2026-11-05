# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a094c8ff53523e88ff9dd28ad467618039e27b58 ("Fix make_timestamp[tz] to accept negative years as meaning BC."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/timestamp.c

Failing oracle cases:
- `src/test/regress||timestamp`

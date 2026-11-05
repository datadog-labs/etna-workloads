# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit e5d64fd6545d1339b58e604b812f1a1200b48839 ("Tighten parsing of datetime input."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/datetime.c

Failing oracle cases:
- `src/test/regress||horology`

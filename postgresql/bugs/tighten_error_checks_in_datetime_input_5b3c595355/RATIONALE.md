# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5b3c5953553bb9fb0b171abc6041e7c7e9ca5b4d ("Tighten error checks in datetime input, and remove bogus "ISO" format."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/datetime.c

Failing oracle cases:
- `src/test/regress||horology`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f2a2bf66c87e14f07aefe23cbbe2f2d9edcd9734 ("Fix extract epoch from interval calculation"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/timestamp.c

Failing oracle cases:
- `src/test/regress||interval`

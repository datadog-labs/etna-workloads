# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 86831952ad6054097dca8aabb1ae4bb74f791f44 ("Ignore temporary relations in RelidByRelfilenumber()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/dbsize.c, src/backend/utils/cache/relfilenumbermap.c

Failing oracle cases:
- `src/test/regress||create_table`

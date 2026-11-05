# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3b6588cd902faa967f61f539f057f9b7643cf6a5 ("Guard against unexpected dimensions of oidvector/int2vector."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/hash/hashfunc.c, src/backend/access/nbtree/nbtcompare.c, src/backend/utils/adt/format_type.c, src/backend/utils/adt/int.c, src/backend/utils/adt/oid.c, src/include/utils/builtins.h

Failing oracle cases:
- `src/test/regress||arrays`

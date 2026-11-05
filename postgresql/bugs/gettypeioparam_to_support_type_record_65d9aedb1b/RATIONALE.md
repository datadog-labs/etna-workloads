# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 65d9aedb1b0e2c160cee3ef6cddb284b092f542e ("Fix getTypeIOParam to support type record[]."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/cache/lsyscache.c

Failing oracle cases:
- `src/test/regress||polymorphism`

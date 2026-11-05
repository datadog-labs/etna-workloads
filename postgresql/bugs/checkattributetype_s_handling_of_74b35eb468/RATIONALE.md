# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 74b35eb468dcf353e25afd4acfc7ee2b2022d6b6 ("Fix CheckAttributeType's handling of collations for ranges."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/catalog/heap.c, src/backend/utils/cache/lsyscache.c, src/include/utils/lsyscache.h

Failing oracle cases:
- `src/test/regress||rangetypes`

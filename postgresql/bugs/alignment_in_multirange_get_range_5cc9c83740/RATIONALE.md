# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5cc9c8374093ba0e427b3309e10077708c156b6a ("Fix alignment in multirange_get_range() function"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/multirangetypes.c

Failing oracle cases:
- `src/test/regress||multirangetypes`

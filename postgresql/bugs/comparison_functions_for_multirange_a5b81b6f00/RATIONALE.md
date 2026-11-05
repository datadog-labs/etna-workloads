# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a5b81b6f0006ea0b502780ce7f73d295a225842c ("Fix bugs in comparison functions for multirange_bsearch_match()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/multirangetypes.c

Failing oracle cases:
- `src/test/regress||multirangetypes`

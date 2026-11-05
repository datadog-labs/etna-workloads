# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 62097a4cc8c725fa86d3170396a8f30609acd0d3 ("Fix selectivity estimation @> (anymultirange, anyrange) operator"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/multirangetypes_selfuncs.c

Failing oracle cases:
- `src/test/regress||multirangetypes`

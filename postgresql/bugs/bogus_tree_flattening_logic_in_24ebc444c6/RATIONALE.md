# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 24ebc444c61306f50777f674544e8559e765ad81 ("Fix bogus tree-flattening logic in QTNTernary()."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/tsquery_util.c

Failing oracle cases:
- `src/test/regress||tsearch`

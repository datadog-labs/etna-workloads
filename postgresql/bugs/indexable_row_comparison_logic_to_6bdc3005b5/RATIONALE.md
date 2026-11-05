# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 6bdc3005b54fc9c6ef27cd4e64edd548315f57ba ("Fix indexable-row-comparison logic to account for covering indexes."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/path/indxpath.c

Failing oracle cases:
- `src/test/regress||index_including`

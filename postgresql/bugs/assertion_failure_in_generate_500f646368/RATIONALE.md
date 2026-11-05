# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 500f646368e4dcfd86daf729ad9481d85b547005 ("Fix assertion failure in generate_orderedappend_paths()"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/allpaths.c

Failing oracle cases:
- `src/test/regress||partition_aggregate`

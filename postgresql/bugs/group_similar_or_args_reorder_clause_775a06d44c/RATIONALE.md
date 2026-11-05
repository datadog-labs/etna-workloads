# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 775a06d44c04e323158826ec256386e7211e154d ("Make group_similar_or_args() reorder clause list as little as possible"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/indxpath.c

Failing oracle cases:
- `src/test/regress||create_index`
- `src/test/regress||join`
- `src/test/regress||partition_join`

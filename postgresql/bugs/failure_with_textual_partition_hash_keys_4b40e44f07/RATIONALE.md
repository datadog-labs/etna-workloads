# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4b40e44f07c727c7a82b291d3b60098dd99f3f64 ("Fix failure with textual partition hash keys."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/partitioning/partbounds.c

Failing oracle cases:
- `src/test/regress||hash_part`

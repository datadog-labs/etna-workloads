# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8cb2a22bbb2cf4212482ac15021ceaa2e9c52209 ("Fix NaN comparison in circle_same test"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/geo_ops.c

Failing oracle cases:
- `src/test/regress||geometry`

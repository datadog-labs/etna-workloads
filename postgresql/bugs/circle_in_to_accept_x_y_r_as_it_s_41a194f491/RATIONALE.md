# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 41a194f49177daf9348bfde2c42e85b806dcee31 ("Fix circle_in to accept "(x,y),r" as it's advertised to do."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/geo_ops.c

Failing oracle cases:
- `src/test/regress||circle`

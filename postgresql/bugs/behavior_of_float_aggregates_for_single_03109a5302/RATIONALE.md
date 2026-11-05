# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 03109a53020e4663df3a8d822cdc665a7d712a93 ("Fix behavior of float aggregates for single Inf or NaN inputs."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/float.c

Failing oracle cases:
- `src/test/regress||aggregates`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7e9f852a79fe19d4d0f18aabc32a620797fb676e ("Ignore PlaceHolderVars when looking up statistics"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/selfuncs.c

Failing oracle cases:
- `src/test/regress||join`

# Rationale

Fix hunk: added `ExpandBlob(pMem)` at the top of `computeNumericType()` in src/vdbe.c, so a zeroblob is materialised before its (not yet existing) `z`/`n` are parsed as a number.

In 3.54.1 the call exists as `if( ExpandBlob(pMem) ){ pMem->u.i = 0; return MEM_Int; }` at the start of `computeNumericType()`. I removed that block, restoring the pre-fix behaviour: the numeric conversion reads the unexpanded zeroblob and truncates it.

Oracle: `zeroblob-13.100` fails (expected `1 X'0000000000000000' 8 3`, got `1 X'' 0 3`). The other 55 cases pass.

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5fcf3945bd90bb0170938ad780159779367dc8ac ("Fix range check in ECPG numeric to int conversion"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/interfaces/ecpg/pgtypeslib/numeric.c

Failing oracle cases:
- `src/interfaces/ecpg||pgtypeslib/num_test`

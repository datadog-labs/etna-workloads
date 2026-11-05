# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3ff660bbeb96086cb1cf880bfb4e2e350cbd21b2 ("Fix off-by-one error in PGTYPEStimestamp_fmt_asc"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/interfaces/ecpg/pgtypeslib/timestamp.c

Failing oracle cases:
- `src/interfaces/ecpg||pgtypeslib/dt_test`

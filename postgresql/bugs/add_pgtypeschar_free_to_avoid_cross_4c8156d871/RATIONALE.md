# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4c8156d87108fa1f245bee13775e76819cd46a90 ("Add PGTYPESchar_free() to avoid cross-module problems on Windows."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/interfaces/ecpg/include/pgtypes.h, src/interfaces/ecpg/include/pgtypes_date.h, src/interfaces/ecpg/include/pgtypes_interval.h, src/interfaces/ecpg/include/pgtypes_numeric.h, src/interfaces/ecpg/include/pgtypes_timestamp.h, src/interfaces/ecpg/pgtypeslib/common.c

Failing oracle cases:
- `src/interfaces/ecpg||pgtypeslib/dt_test`
- `src/interfaces/ecpg||pgtypeslib/dt_test2`
- `src/interfaces/ecpg||pgtypeslib/num_test`
- `src/interfaces/ecpg||pgtypeslib/num_test2`
- `src/interfaces/ecpg||preproc/outofscope`
- `src/interfaces/ecpg||sql/sqlda`

# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a14ba29b15a8b342808702e9da3e4a4532044f61 ("ecpg: Fix out-of-bound writes due to processing of invalid bytea data"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/interfaces/ecpg/ecpglib/data.c, src/interfaces/ecpg/ecpglib/error.c, src/interfaces/ecpg/include/ecpgerrno.h

Failing oracle cases:
- `src/interfaces/ecpg||sql/bytea`

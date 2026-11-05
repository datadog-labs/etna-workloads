# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3aaefe8924f4828eabd414bfda98793e769aed8e ("Prevent access to other sessions' empty temp tables"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/storage/buffer/bufmgr.c, src/include/utils/rel.h

Failing oracle cases:
- `src/test/modules/test_misc|t/013_temp_obj_multisession.pl|INSERT (caught via hio.c)`

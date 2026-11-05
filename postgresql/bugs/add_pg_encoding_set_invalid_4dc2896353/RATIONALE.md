# Rationale
Changed src/src/common/wchar.c: pg_big5_verifychar, pg_gbk_verifychar, pg_uhc_verifychar.
Traces to the three fix.patch hunks adding the `l == 2 && s[0]==NONUTF8_INVALID_BYTE0 && s[1]==NONUTF8_INVALID_BYTE1 -> return -1` check.
I removed those checks. The pair 0x8d 0x20 is then accepted as valid in BIG5/GBK/UHC, so pg_encoding_set_invalid()'s output
(used by libpq/fe_utils escaping) is no longer invalid, and the invalid-byte-pair test fails.

Failing oracle case: src/test/regress||conversion

# Rationale

Changed hunks (all trace to fix_impl.patch):

1. src/include/regex/regcustom.h, CHR_MAX: restored `0xfffffffe` (fix hunk changed it to `0x7ffffffe`). Allows chr values beyond what fits in an int/celt, so range arithmetic can overflow.
2. src/backend/regex/regc_lex.c, lexescape(), cases `\u`, `\U`, `\x`: dropped the out-of-range check on the parsed value (fix added `c < CHR_MIN || c > CHR_MAX`; current code spells it `!CHR_IS_IN_RANGE(c)`). Out-of-range escapes are accepted again instead of raising REG_EESCAPE.

Not reproduced: the regc_locale.c range() hunk (current code already has the fixed form) and the regcomp.c dovec() NOERR hunks (dovec no longer exists).

Failing oracle case: src/test/regress||regex

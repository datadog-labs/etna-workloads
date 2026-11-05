# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3db322eaab9688d57643b4d2a5f52b7f350ef46f ("Prevent internal overflows in date-vs-timestamp and related comparisons."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/date.c, src/backend/utils/adt/jsonpath_exec.c, src/backend/utils/adt/timestamp.c, src/include/utils/date.h, src/include/utils/timestamp.h

Failing oracle cases:
- `src/test/regress||horology`

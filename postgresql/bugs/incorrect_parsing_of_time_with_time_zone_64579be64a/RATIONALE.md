# Rationale

File: src/backend/utils/adt/datetime.c, function DecodeTimeOnly (two hunks).

fix.patch added "a date has to be specified" checks (`(fmask & DTK_DATE_M) != DTK_DATE_M` -> DTERR_BAD_FORMAT) in two places. The code has been refactored since, so the hunks map to:

1. Named-timezone block (`if (namedTz != NULL)`, non-DST-zone `else` branch): removed the check before `DetermineTimeZoneOffset(tm, namedTz)`. This traces to the first fix hunk. Input like '15:36:39 m2' is then accepted, using a partial or garbage date.
2. Dynamic-abbreviation block (`if (abbrevTz != NULL)`): removed the check in the `else` branch before copying tm_year/mon/mday. This traces to the second fix hunk. Input like '15:36:39 MSK m2' is then accepted.

Without the checks, a partially specified date is used to resolve the timezone offset instead of the input being rejected.

The session-timezone block already had the check in the original code, so I left it alone.

Failing oracle case: src/test/regress||timetz

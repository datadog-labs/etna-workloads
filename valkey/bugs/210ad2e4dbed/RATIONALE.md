# Rationale

Both changes are in `getTimeoutFromObjectOrReply()` in `src/timeout.c`.

1. Fix hunk 1 (`ftval *= 1000.0; if (ftval > LLONG_MAX) error`): in 9.0.7 the
   check is `ftval > (long double)LLONG_MAX`. I removed it, which restores the
   pre-fix code that casts the scaled seconds value to long long without a range
   check. Remaining code (`ceill`, `ftval *= 1000.0`) is unrelated and left as is.
2. Fix hunk 2 (`if (tval > LLONG_MAX - now) error` before `tval += now`): I removed
   the check in 9.0.7, so `tval += now` can overflow again. This is the same defect
   and it covers the millisecond path (WAIT).

Oracle cases expected to fail:
- `BLPOP: timeout value out of range` (`BLPOP blist1 0x7FFFFFFFFFFFFF` no longer
  returns "is out of range").
- `WAIT out of range timeout (milliseconds)` (`wait 2 9223372036854775807` no longer
  returns "timeout is out of range").

check.sh result:
- list.tcl: 1 of 261 oracle cases fails, `BLPOP: timeout value out of range`:
  expected `ERR *is out of range*`, got `ERR timeout is negative` (the overflowed
  value wraps negative).
- wait.tcl: 37 of 38 oracle cases fail, including
  `WAIT out of range timeout (milliseconds)`. I did not inspect the output of this
  file beyond the summary line, so I don't know why the other 36 fail; they are
  probably knock-on effects of the first failure.

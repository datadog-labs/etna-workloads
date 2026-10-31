# Rationale

Both changes are in `Lib/logging/handlers.py` (`TimedRotatingFileHandler`).

1. `computeRollover`: `if r <= 0:` -> `if r < 0:`. Reverses the fix hunk that
   changed `r < 0` to `r <= 0`. With `r == 0` (current time exactly equals the
   rotate time) the result is `currentTime` itself rather than the next day, so
   computeRollover no longer always returns a timestamp larger than its input.

2. `doRollover`: the "Already rolled over" early return is replaced by the old
   behaviour: close the stream first, then `os.remove(dfn)` if the destination
   exists, then rotate. Reverses the fix hunk that stopped overwriting an
   existing rolled-over file (data loss). (v3.15.2 computes `rolloverAt` before
   this check; that line is left untouched.)

## Oracle failures
9 failures in test_logging, including `test_rollover_existing_backup`
(existing backup file overwritten: 'a\n' != 'existing\n') and the
midnight/weekday rollover and computeRollover boundary tests.

# Rationale

The fix added an explicit `stride_usecs == 0` check ("stride cannot equal zero") before the modulo in `timestamp_bin` and `timestamptz_bin`. Since then, the code has changed. Both functions are now `timestamp_bin` / `timestamptz_bin` in `src/backend/utils/adt/timestamp.c`, and they check `stride_usecs <= 0` ("stride must be greater than zero").

Changed hunks, both tracing to the fix_impl.patch hunks that add the zero-stride check:
- `timestamp_bin`: the check `stride_usecs <= 0` became `stride_usecs < 0`.
- `timestamptz_bin`: the same change.

With these edits, a zero stride (e.g. `'0 days'::interval`) is no longer rejected. It reaches `tm_diff % stride_usecs`, which is a division by zero (SIGFPE, or a crash).

Failing oracle cases:
- src/test/regress||timestamp
- src/test/regress||timestamptz

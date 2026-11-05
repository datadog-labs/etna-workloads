# Rationale

The fix replaced the bodies of `timestamp_zone_transform()` and `timestamp_izone_transform()` with `return NULL`. That disabled the optimization that replaced AT TIME ZONE with a RelabelType. This change brings the optimization back. The old `protransform` hook no longer exists, so it is re-expressed as `prosupport` functions that answer `SupportRequestSimplify`.

- `src/backend/utils/adt/timestamp.c`, new `timestamp_zone_support()`. This traces to the fix hunk for `timestamp_zone_transform`. If the zone is a Const equivalent to UTC, it returns the timestamp argument wrapped in a RelabelType. The zone lookup uses today's `DecodeTimezoneName` instead of the old `DecodeTimezoneAbbrev` call.
- `src/backend/utils/adt/timestamp.c`, new `timestamp_izone_support()`. This traces to the fix hunk for `timestamp_izone_transform`. If the zone is a Const zero interval, it returns the timestamp argument wrapped in a RelabelType.
- `src/include/catalog/pg_proc.dat`. This is not a hunk of `fix_impl.patch`. It is the wiring the current code needs for the restored functions to run. It adds two `pg_proc` entries (OIDs 9252 and 9253) for the support functions. It also adds `prosupport` to the four `timezone()` entries: `timestamptz_zone`, `timestamptz_izone`, `timestamp_zone` and `timestamp_izone`.

Together these relabel Vars again, which breaks index matching and gives the wrong plan or result in the regression test.

Failing oracle case: `src/test/regress||timestamptz`.

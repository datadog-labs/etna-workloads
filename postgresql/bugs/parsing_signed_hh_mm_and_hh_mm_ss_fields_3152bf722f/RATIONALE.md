# Rationale

File: src/backend/utils/adt/datetime.c, function DecodeInterval, case DTK_TZ (signed hh:mm[:ss]).

Both changes trace to the single datetime.c hunk in fix_impl.patch.

1. The signed-time `DecodeTimeForInterval(field[i] + 1, ...)` call takes `INTERVAL_FULL_RANGE` again instead of `range`. The fix passed `range`. Without it, the typmod range restrictions are ignored for signed time fields.
2. `tmask = DTK_M(TZ);` is restored after `type = DTK_DAY;`. The fix removed it. It overwrites the mask that DecodeTimeForInterval computed, so the field mask is wrong. Later fields can then be accepted or rejected incorrectly, and duplicate time fields are not detected.

Failing oracle case: src/test/regress||interval

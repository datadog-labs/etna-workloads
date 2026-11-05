# Rationale

## Changed hunk
- File/function: `src/backend/access/transam/xlog.c`, `GetWALAvailability()`.
- Traces to: the `GetWALAvailability` hunk of fix.patch (`if (targetSeg >= oldestSeg) {...}` replaced by the `oldestSlotSeg`-based logic).
- Change: I restored the pre-fix status calculation.
  - Segments still on disk (`targetSeg >= oldestSeg`) report "reserved" only when `max_slot_wal_keep_size` is unset or at least `max_wal_size`, and the target is within `max_wal_size`.
  - Otherwise they report "extended" if a slot retains them.
  - The `WALAVAIL_UNRESERVED` state is never returned.
  - The enum names stay the new ones, so the old normal/reserved map to RESERVED/EXTENDED.
- Why it brings the bug back: a slot whose WAL is no longer protected but not yet removed is no longer reported as "unreserved". When `max_slot_wal_keep_size` is smaller than `max_wal_size`, a slot that is still within `max_wal_size` is reported as "extended" instead of "reserved". The status can also be reported as "reserved" or "extended" for segments that are already lost.

## Failing oracle cases
Confirmed by the oracle run (1 of 26 fails):
- `src/test/recovery|t/019_replslot_limit.pl|check that the slot state changes to "unreserved"`

The other 25 cases pass.

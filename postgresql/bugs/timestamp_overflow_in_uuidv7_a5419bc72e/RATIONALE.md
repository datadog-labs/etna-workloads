# Rationale

File: src/backend/utils/adt/uuid.c (fix.patch has one file; all hunks below trace to it)

- `generate_uuidv7()` and its prototype: restored the signed `int64 ns` signature, computing
  `unix_ts_ms = ns / NS_PER_MS` and the sub-ms fraction from `ns % NS_PER_MS` internally
  (reverses the hunks changing the signature to `uint64 unix_ts_ms, uint32 sub_ms`).
- `uuidv7()`: passes `get_real_time_ns_ascending()` directly (reverse of the split into ms/sub-ms).
- `uuidv7_interval()`: converts the shifted timestamp back to nanoseconds
  (`(ts + epoch offset) * NS_PER_US + ns % NS_PER_US`) instead of passing ms/sub-ms separately
  (dropped `us` variable and US_PER_MS use). For far-future timestamps (still allowed by the
  range check, up to year ~10889) the multiplication overflows int64, giving a wrong timestamp.

Oracle case expected to fail: src/test/regress||uuid

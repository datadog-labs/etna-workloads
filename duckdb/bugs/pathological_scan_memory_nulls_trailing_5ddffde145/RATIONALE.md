# Rationale

All changes are in `src/src/include/duckdb/storage/string_uncompressed.hpp`.

The fix short-circuited negative-offset entries with computed length 0 (NULLs trailing an overflow string), so they did not go through ReadOverflowString. In today's code that logic exists in two places, and I undid both.

1. `FetchStringFromDict` (fix hunk, verbatim): removed the `else if (string_length == 0) { return string_t(base_ptr, 0); }` branch. A NULL with an inherited negative offset now follows the marker into ReadOverflowString again.
2. `ValidatedStringRange::GetEntry` (the same fix expressed in today's main scan path): `is_overflow` was `current_offset < 0 && string_length > 0` and is now `current_offset < 0`. This is the same length-0 short-circuit, so a trailing NULL is treated as an overflow string again.
3. `FetchStringFromEntry`: removed `D_ASSERT(entry.data.size() == BIG_STRING_MARKER_SIZE)`. Without this, the build (assertions on) throws an INTERNAL error at CREATE TABLE. That would be a different failure from the original bug. The assertion states the invariant that the guard in (2) enforced, so it goes away with it.

## Oracle
Before change 2, the test passed (0 of 1 failed), because `GetEntry` still guarded the NULLs. With changes 1 and 2 but not 3, it failed on the assertion at CREATE TABLE. With all three:

```
FAIL     test/sql/storage/overflow_strings/null_overflow_string_memory.test
         test/sql/storage/overflow_strings/null_overflow_string_memory.test:53
         SELECT sum(length(v)) FROM t;
         Out of Memory Error: could not allocate block of size 2.0 MiB (487.5 MiB/488.2 MiB used)
1 of 1 oracle units fail
```

Each trailing NULL re-reads the 2MB overflow string, which exceeds the 512MB limit.

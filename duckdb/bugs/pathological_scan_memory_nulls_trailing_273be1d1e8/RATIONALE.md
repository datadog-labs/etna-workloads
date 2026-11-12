# Rationale

In today's code the scan goes through `FetchStringFromEntry`, fed by `ValidatedStringRange::GetEntry`
and a second entry builder in string_uncompressed.cpp. The fix's guard lives there as `string_length > 0`.
Removing only the `FetchStringFromDict` branch did NOT fail the oracle (first attempt: PASS), so the guards were removed.

Hunks (all trace to the fix's "negative offset + length 0 => empty string, not overflow" short-circuit):
1. src/src/include/duckdb/storage/string_uncompressed.hpp, `ValidatedStringRange::GetEntry`:
   `is_overflow = current_offset < 0 && string_length > 0` -> `current_offset < 0`.
   A NULL inheriting the previous overflow offset is again treated as overflow and routed to ReadOverflowString.
2. src/src/storage/compression/string_uncompressed.cpp (~line 462): same change for the other entry builder.
3. string_uncompressed.hpp `FetchStringFromEntry`: removed `D_ASSERT(entry.data.size() == BIG_STRING_MARKER_SIZE)`,
   which would otherwise fire on the zero-length NULL entries (debug build) and fail the test with an assertion
   instead of the memory blowup. `FetchStringFromDict` is left with the fix's string_length==0 branch (unchanged).

Result: each trailing NULL re-reads/allocates the 2MB overflow string; the test OOMs under memory_limit=512MB.

etna-check:
FAIL     test/sql/storage/overflow_strings/null_overflow_string_memory.test
         Out of Memory Error: could not allocate block of size 2.0 MiB (487.5 MiB/488.2 MiB used)
1 of 1 oracle units fail

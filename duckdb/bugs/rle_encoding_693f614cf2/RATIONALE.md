# Rationale

Hunk: src/storage/compression/rle.cpp, RLEState::Update (analyze path).
Traces to the fix's hunk replacing `last_value == data[idx]` with `RLEValueEqual(last_value, data[idx])`.
Reverted the call to plain `last_value == data[idx]`, so IEEE equality merges +0.0 and -0.0 into one run
and the signed zero is lost. (The helper definitions remain in today's code, now unused; the fix's
other hunks, the helper and include, exist already in v2.0.0 in a different form.)

Oracle: test/sql/storage/compression/rle/rle_signed_zero.test should fail (see etna-check output below).

## etna-check result
```
FAIL     test/sql/storage/compression/rle/rle_signed_zero.test
         Wrong result in query! (rle_signed_zero.test:16)
         SELECT signbit(x) FROM t WHERE x = 0 ORDER BY signbit(x);
         Expected: false, true   Actual: 1, 1
1 of 1 oracle units fail
```
-0.0 and 0.0 were merged into one run, so both read back as -0.0.

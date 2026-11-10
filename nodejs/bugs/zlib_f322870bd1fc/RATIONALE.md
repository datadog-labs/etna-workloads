# Re-introduced bug: zlib pledgedSrcSize validation

**Bug:** `pledgedSrcSize` (an exact byte count) was not validated as a non-negative safe integer. Native code coerced numbers via `IntegerValue()` (NaN -> 0, 1.9 -> 1, Infinity/huge values -> clamped), and non-numbers (`'1'`, `null`) were silently ignored. zlib/iter had its own weaker JS check (NaN/negative only; no Infinity/fractional/unsafe checks, wrong error codes for them).

## Hunks
- `src/node_zlib.cc` (`ZstdStream::Init`): reverses the native hunk. Restored `if (args[1]->IsNumber())` + `IntegerValue()` with `ERR_INVALID_ARG_VALUE` errors; non-numbers are ignored again, no safe-integer check.
- `lib/zlib.js` (`Zstd` constructor): reverses `opts?.pledgedSrcSize` -> `opts?.pledgedSrcSize ?? undefined`, so `null` is turned into undefined and silently accepted.
- `lib/internal/streams/iter/transform.js` (`createZstdHandle`): restored the old JS-only check (type/NaN, `< 0`), replacing the native validation reliance; Infinity, 1.9 and unsafe ints are no longer rejected with RangeError.

## Failing tests
Both `parallel/test-stream-iter-validation` and `parallel/test-zlib-zstd-pledged-src-size` print `not ok` (stable across runs): the new-style cases expecting `ERR_OUT_OF_RANGE`/`ERR_INVALID_ARG_TYPE` for NaN, Infinity, 1.9, unsafe ints, `'1'`, and `null` no longer throw (or throw the wrong code).

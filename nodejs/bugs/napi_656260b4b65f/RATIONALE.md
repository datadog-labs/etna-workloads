# RATIONALE: Reintroduction of CVE-2020-8174 (N-API memory corruption)

## The bug

`napi_get_value_string_latin1`, `napi_get_value_string_utf8`, and
`napi_get_value_string_utf16` in `src/js_native_api_v8.cc` accept a caller-supplied
output buffer `buf` and its size `bufsize`. When `buf` is non-null, these functions
compute a write length from `bufsize - 1` (to leave room for a null terminator) and
then perform a write of that length into `buf`.

The defect: when a caller passes `bufsize == 0` together with a non-null `buf` (a
legal, documented combination — "if buf is not NULL and bufsize is 0, result is not
set and no bytes are copied" was in fact *not* honored by the buggy code), the
expression `bufsize - 1` underflows because `bufsize` is an unsigned `size_t`. The
subtraction wraps around to `SIZE_MAX`, so the code proceeds to write a huge number
of bytes (the full length of the source JS string, effectively unbounded) into the
caller's buffer instead of treating "copy zero bytes" as a no-op. This causes a
massive heap buffer overflow / memory corruption whenever an addon calls one of
these functions with a non-null buffer of size 0, which is exactly the scenario
regression-tested by `test_string.c`'s `TestMemoryCorruption` (it passes `buf` with
`bufsize = 0` and a 64KiB JS string, expecting nothing to be written into `buf`).

## Hunks

All three hunks mirror the same change in the upstream fix (656260b4b65fec3b10f6da3fdc9f11fb941aafb5), re-expressed against the current (V8 "V2" write API) implementation that has replaced the older `WriteOneByte`/`WriteUtf8`/`Write` calls since the fix landed:

1. **`napi_get_value_string_latin1`** (src/js_native_api_v8.cc): changed
   `} else if (bufsize != 0) { ... } else if (result != nullptr) { *result = 0; }`
   back to a single unconditional `} else { ... }` branch, removing the `bufsize != 0`
   guard. This corresponds to the fix's hunk on
   `napi_get_value_string_latin1` (`- } else {` / `+ } else if (bufsize != 0) {` plus
   the added `else if (result != nullptr) { *result = 0; }` branch) — reverting it
   restores the old behavior where the write path (and the `bufsize - 1` underflow)
   executes unconditionally whenever `buf` is non-null, regardless of `bufsize`.

2. **`napi_get_value_string_utf8`** (src/js_native_api_v8.cc): identical change
   applied to `napi_get_value_string_utf8`'s write branch (`WriteUtf8V2` call site),
   corresponding to the fix's second hunk on `napi_get_value_string_utf8`.

3. **`napi_get_value_string_utf16`** (src/js_native_api_v8.cc): identical change
   applied to `napi_get_value_string_utf16`'s write branch (`WriteV2` call site),
   corresponding to the fix's third hunk on `napi_get_value_string_utf16`.

In every case, the `bufsize - 1` subtraction that feeds the length of the V8 write
call is now reached even when `bufsize == 0`, reproducing the unsigned-integer
underflow and resulting out-of-bounds write that the original CVE-2020-8174 fix
eliminated. No changes were made to `lib/`, tests, or build files.

## Test results

Oracle test `js-native-api/test_string/test` fails after this change:

```
TAP version 13
1..1
not ok 1 js-native-api/test_string/test
  ---
  duration_ms: ~210-250
  severity: crashed
  exitcode: -11
  stack: |-
  ...
```

The process crashes with SIGSEGV (exit code -11) while executing
`test_string.TestMemoryCorruption(' '.repeat(64 * 1024))`, which calls
`napi_get_value_string_utf8(env, args[0], buf, 0, NULL)` with a 10-byte stack buffer
`buf` and `bufsize = 0`. With the bug reintroduced, the underflowed length causes an
attempt to write ~64KiB of UTF-8 data into the 10-byte stack buffer, corrupting the
stack and crashing the process. This was reproduced stably across two consecutive
test runs.

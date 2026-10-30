# Rationale

The fix replaced the `eptr[0] != '\0'` end-of-parse test with a comparison of the parsed length against `sdslen`. Both double parsers, in `src/util.c`, now carry that length check, so I removed it from each:

- `string2d` (used by `getDoubleFromObject`, the 9.0.7 successor of the fix's first hunk): dropped `(size_t)(eptr - s) != slen`. The parser now relies on `eptr[0] != '\0'`, as before the fix. A string with an embedded NUL, such as "1\0002", is accepted because strtod stops at the NUL.
- `string2ld` (used by `getLongDoubleFromObject`, the second hunk): dropped `(size_t)(eptr - buf) != slen`. It keeps `eptr[0] != '\0'`. The string is copied into `buf`, so the embedded NUL still stops strtold early and is accepted.

Oracle case that fails: "string to double with null terminator" in `tests/unit/type/incr.tcl`. `INCRBYFLOAT` on "1\0002" returns `2` instead of an `ERR ... valid` error. This is the same symptom as the original bug. All other incr cases pass.

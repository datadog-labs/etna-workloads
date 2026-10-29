# Rationale

Fix hunk (src/func.c, torealFunc, SQLITE_INTEGER case): the fix made toreal()
of an integer return the real only if the conversion is lossless
(`iVal==rVal`); the pre-fix code returned `(double)sqlite3_value_int64(argv[0])`
unconditionally. In 3.54.1 the function lives in ext/misc/totype.c (toreal()),
with the check written as `iVal==totypeDoubleToInt(rVal)`.

Change: in ext/misc/totype.c toreal(), SQLITE_INTEGER case, restored the
unconditional `sqlite3_result_double(context, (double)sqlite3_value_int64(argv[0]))`.

Oracle failures (test/func4.test): func4-2.24 and func4-2.26. Both
toreal() of -9223372036854775808 (via -9223372036854775807 - 1) are expected
to be NULL-ish/lossless-checked and now return a value instead of the
expected result. (Other boundary cases like 2.25/2.27 are platform-dependent
and still pass here.)

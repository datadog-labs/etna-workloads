# Re-introduced bug: napi_create_string_* crash on NULL string

**Bug.** `napi_create_string_latin1/utf8/utf16` did not null-check the `str` argument
(when `length > 0`, including `NAPI_AUTO_LENGTH`) before handing it to V8, so a NULL
pointer caused a segfault instead of returning `napi_invalid_arg`.

**Change (src/js_native_api_v8.cc, one hunk).** In today's code the three fix hunks
(`if (length > 0) CHECK_ARG(env, str);` in each of the three functions) have been
consolidated into the shared macro `CHECK_NEW_STRING_ARGS`, used by `v8impl::NewString`.
I removed the line `if ((length) > 0) CHECK_ARG((env), (str));` from that macro, which is
equivalent to removing the check from all three functions (it also affects the external-string
variants that share the macro).

**Failing test.** `js-native-api/test_string/test_null` -> `not ok`, severity: crashed,
exitcode -11 (SIGSEGV) when the addon calls `napi_create_string_*(env, NULL, NAPI_AUTO_LENGTH, &result)`.

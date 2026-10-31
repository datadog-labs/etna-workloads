# Rationale

## Modules/_hashopenssl.c
Fix hunk: in `py_digest_by_name`, `_setException(PyExc_ValueError, ...)` became
`_setException(state->unsupported_digestmod_error, ...)`.

In v3.15.2 that code is `get_openssl_evp_md_by_utf8name`, which calls
`raise_unsupported_str_algorithm_error`. I made that helper raise plain
`PyExc_ValueError` instead of `state->unsupported_digestmod_error`. It has one
caller, so nothing else is affected. `hmac.digest` and `HMAC.__init__` only
catch `UnsupportedDigestmodError` before falling back to the builtin
constructor, so a plain `ValueError` escapes and the fallback never runs.

## Oracle failures
`test_hmac` reports 5 errors. They include `test_with_fallback`, which fails
with `ValueError: [digital envelope routines] unsupported hash algorithm foo`
from `hmac.digest(b'key', b'message', 'foo')`.

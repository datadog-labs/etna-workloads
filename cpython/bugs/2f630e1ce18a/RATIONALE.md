# Rationale

Fix hunk reversed: `Lib/urllib/parse.py` `urlsplit` — the added
`url = url.lstrip(_WHATWG_C0_CONTROL_OR_SPACE)` and
`scheme = scheme.strip(_WHATWG_C0_CONTROL_OR_SPACE)`.
In v3.15.2 this logic lives in `_urlsplit()` (the scheme strip is inside the
`if scheme is not None:` block); I removed both lines (and the now-stale comment).
Unsafe-byte removal (\t \r \n) is kept, as before the fix. The constant is left defined.

Failing oracle case: `test_urlsplit_strip_url` — a URL with leading C0/space
noise gets `scheme == ''` instead of `'http'`.

# Rationale

Fix hunk reversed: the `urlsplit` hunk in Lib/urllib/parse.py that added
`if '[' in netloc and ']' in netloc: ... _check_bracketed_host(...)`.

In v3.15.2 that call is `_check_bracketed_netloc(netloc)` (which extracts the
host and calls `_check_bracketed_host`). I removed that call from `urlsplit`,
so bracketed hosts are no longer validated as IPv6/IPvFuture, as before the fix.
The helper functions stay in place but are unused; the fix's `import ipaddress`
and helper definitions are left untouched.

Oracle failure: `test_invalid_bracketed_hosts` fails, since
`urlsplit('Scheme://user@[192.0.2.146]/Path?Query')` no longer raises ValueError.

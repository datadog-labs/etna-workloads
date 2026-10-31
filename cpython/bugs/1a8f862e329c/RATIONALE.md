# Rationale

All changes are in `tree/Lib/http/client.py`, reversing the fix's `client.py` hunks (docs/tests/NEWS untouched).

- `set_tunnel`: Host-header generation block removed (reverses the added `if not any(header.lower() == "host" ...)` block). `headers.copy()` reverted to `headers` (reverses the `.copy()` hunk), so the caller's dict is stored directly.
- `_tunnel`: the request line is hardcoded `HTTP/1.0` again instead of `self._http_vsn_str` (reverses the HTTP/1.1 upgrade). The v3.15 `_wrap_ipv6`/idna handling is kept, since it is later code not part of this fix.

## Oracle failures
8 test_httplib TunnelTests fail, e.g. `test_set_tunnel_host_port_headers_add_host_missing` (no `Host` in `_tunnel_headers`), and the `test_connect_with_tunnel*` / `test_connect_put_request` / idna cases (CONNECT sent as `HTTP/1.0` without `Host:`).

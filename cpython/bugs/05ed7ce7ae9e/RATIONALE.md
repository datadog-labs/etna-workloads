# Rationale

Bug: gh-146211, CR/LF (and other illegal characters) accepted in
`HTTPConnection` tunnel host and tunnel request headers, allowing header injection in the CONNECT request.

Changes, all in `Lib/http/client.py` `_tunnel()`:

1. Removed the `_contains_disallowed_url_pchar_re` check on `self._tunnel_host`.
   This reverses the fix's first hunk (the "Tunnel host can't contain control characters" ValueError).
2. Replaced the per-header validation (`_is_legal_header_name`, `_is_illegal_header_value`)
   with the original `headers.append(f"{header}: {value}\r\n".encode("latin-1"))`.
   This reverses the second hunk. The only difference from the pre-fix code in v3.15.2
   was `str(value)`, which the f-string already does.

Failing oracle cases: `test_invalid_tunnel_headers` (all subtests; no ValueError is raised, the request goes out)
and `test_invalid_tunnel_host`. The check run shows 21 errors in total, with `RemoteDisconnected` from the fake socket instead of the expected `ValueError`.

# Rationale

All changes are in `Lib/http/client.py`, reverting the three hunks of fix.patch (gh-100985):

1. `_get_hostport`: the `[...]` stripping was moved back inside the `if port is None:` branch, so it is skipped when an explicit port is passed (e.g. `set_tunnel('[1:2:3::4]', 1234)`). This reverses the dedent in the fix.
2. `_tunnel`: removed the `_wrap_ipv6` call and the `_wrap_ipv6` helper, so `CONNECT` is sent with an unbracketed IPv6 host. This reverses the fix's helper and use in `_tunnel`.
3. `putrequest`: restored the old `if ":" in host: host_enc = b'[' + host_enc + b']'` wrapping, replacing the `_wrap_ipv6` call. This is the pre-fix code and double-wraps when the host still has brackets.

Failing oracle cases: `test_connect_put_request_ipv6` and/or `_ipv6_port` fail because the request contains
`CONNECT 1:2:3::4:1234` instead of `CONNECT [1:2:3::4]:1234`. check.sh reported 1 failure.

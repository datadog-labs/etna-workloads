# CVE-2022-32212: IPv4 validation in inspector_socket

**Bug.** `IsIPAddress()` in `src/inspector_socket.cc` decided whether a Host header is an IPv4 address by checking only that every character is a digit or '.', and that there are exactly 3 dots. Hosts such as `10.0.2.555`, `127..0.1`, `.0.0.1`, `127.0.0.`, `127.0.0.4294967296` or octal/leading-zero octets (`0177.0.0.1`) were accepted as IP addresses. This allows DNS-rebinding hosts to pass the inspector Host check.

**Change (single hunk, `IsIPAddress` IPv4 branch).** Corresponds to the fix's hunk in `IsIPAddress`, re-expressed for today's code. The fix introduced strict octet parsing. Today's code does that with `uv_inet_pton(AF_INET, ...)`, a later rewrite. I replaced it with the pre-fix loop (digits and '.' only, `quads == 3`). I kept the `0.0.0.0/8` rejection, which is a separate later fix, as a simple `"0."` prefix check, so unrelated tests still pass.

**Failing cctest cases** (failure at test_inspector_socket.cc:323, the handshake is accepted and the test times out after 5s instead of seeing a failure): HostIPChecked, HostIpOctetOutOfIntRangeChecked, HostIpOctetFarOutOfIntRangeChecked, HostIpEmptyOctetStart/Mid/EndChecked, HostIpInvalidOctalOctetStart/Mid/EndChecked, HostIpLeadingZeroStart/Mid/EndChecked, and the other invalid-IP cases.

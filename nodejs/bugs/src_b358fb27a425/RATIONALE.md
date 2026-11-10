# Re-introduced bug: IPv4 non-routable host validation (CVE-2022-32212)

**Bug:** The inspector's Host header validation (`IsIPAddress` in `src/inspector_socket.cc`) accepts `0.0.0.0` (and all of 0.0.0.0/8) as a valid IPv4 host. On macOS, 0.0.0.0 can reach localhost, so a DNS-rebinding attacker could reach the inspector.

**Hunk:** The upstream fix added `if (host.front() == '0') return false;`. Today the code has been rewritten to parse with `uv_inet_pton` and then reject with `if (ipv4[0] == 0) return false;`, together with its explanatory comment. I removed that check and its comment. The result is the pre-fix behaviour: any syntactically valid dotted-decimal address, including 0.x.x.x, is accepted.

**Failing test:** `InspectorSocketTest.HostIPNonRoutable` fails (it fails on both runs).
`test_inspector_socket.cc:323: Value of: (!expectation.read_expected) Actual: true Expected: false`, because the handshake succeeds for `Host: 0.0.0.0:9229`.
The other 39 InspectorSocketTest cases pass.

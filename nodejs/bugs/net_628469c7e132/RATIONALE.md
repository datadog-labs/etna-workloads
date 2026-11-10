# Re-introduced bug: server.listen picks link-local IPv6 address (nodejs/node#51732)

**Bug:** `server.listen(port, host)` resolved the host with a single-result `dns.lookup`, so when the first
result was an IPv6 link-local address (`fe80::/10`) it was used and listen failed, even if a usable address
(e.g. `::1` or `127.0.0.1`) was also returned.

**Change (lib/net.js only):**
- `lookupAndListen`: reverts the fix hunk that switched to `dns.lookup(address, { all: true }, ...)` plus
  `filterOnlyValidAddress`; it is back to the single-address `doListen(err, ip, addressType)` callback.
- Removed `isIpv6LinkLocal` / `filterOnlyValidAddress` (fix hunk adding them) and the
  `convertIpv6StringToBuffer` import (fix hunk), since they would be unused. The C++ binding in
  src/cares_wrap.cc is left in place (harmless, unused).

**Failing test:** sequential/test-net-server-listen-ipv6-link-local (not ok): the mocked `dns.lookup` returns
arrays for `{all:true}`, which the old single-result callback no longer handles, so the expected
addresses (127.0.0.1 / ::1) are not selected.

# Bug
Hostnames containing NUL bytes (e.g. `127.0.0.1\u0000.allowed.example`) were accepted by `dns.lookup`, `dns.promises.lookup` and `net.connect` (`options.host`), since only `validateString` was applied (CVE-2026-48930).

# Changes (the validator helper itself is kept; only call sites reverted)
- lib/dns.js `lookup`: `validateStringWithoutNullBytes(hostname)` -> `validateString` (fix hunk in lib/dns.js).
- lib/internal/dns/promises.js `lookup`: same revert (fix hunk in promises.js).
- lib/net.js `lookupAndConnect`: `validateStringWithoutNullBytes(host, 'options.host')` -> `validateString` (fix hunk in net.js).
The validators.js hunk is not reverted: the helper is now used elsewhere in the release.

# Failing tests
parallel/test-dns-lookup and parallel/test-net-connect-options-invalid: the expected ERR_INVALID_ARG_VALUE "must be a string without null bytes" is no longer thrown (assert.throws reports "Missing expected exception").

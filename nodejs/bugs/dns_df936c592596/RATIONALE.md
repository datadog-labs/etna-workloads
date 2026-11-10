# Rationale
Bug: `dns.lookupService()` and `dns.promises.lookupService()` named their first argument `hostname` although it must be an IP address, so ERR_MISSING_ARGS / ERR_INVALID_ARG_VALUE errors said "hostname" instead of "address".

Hunks:
- lib/dns.js lookupService: renamed param `address` -> `hostname` (ERR_MISSING_ARGS, validateString, ERR_INVALID_ARG_VALUE, req.hostname, getnameinfo, DNSException, perf detail) — corresponds to the fix's lib/dns.js hunk, re-expressed for current code (validateString/validatePort).
- lib/internal/dns/promises.js lookupService: same rename — corresponds to the fix's promises.js hunk.

Failing: parallel/test-dns (stable over 2 runs):
expected `The "address", "port", and "callback" arguments must be specified`, actual `The "hostname", "port", and "callback" ...`.

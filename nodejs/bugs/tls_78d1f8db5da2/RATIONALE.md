# Re-introduced bug: SecureContext options not forwarded (nodejs/node#36416)

**Bug.** Places that forward TLS options one by one omitted newer SecureContext options. `https.Agent#getName` ignored `sigalgs`, `privateKeyIdentifier` and `privateKeyEngine`, so sockets for connections differing only in those options could be wrongly shared. The server's `setSecureContext` did not forward `privateKeyIdentifier` or `privateKeyEngine` to `createSecureContext`.

## Hunks
1. `lib/https.js`, `Agent.prototype.getName`. This matches the fix's https.js hunk. I removed the three `':' + value` segments for sigalgs, privateKeyIdentifier and privateKeyEngine, and the now-unused `JSONStringify` primordial import. The name no longer varies with those options.
2. `lib/internal/tls/wrap.js`, `Server.prototype.setSecureContext`. In today's tree this code lives in `lib/internal/tls/wrap.js`, not `lib/_tls_wrap.js`. This matches the fix's `_tls_wrap.js` setSecureContext hunk. I removed the `this.privateKeyIdentifier`/`this.privateKeyEngine` assignments and the two keys passed to `tls.createSecureContext`.

The fix's `Server.prototype.setOptions` hunk has no counterpart. `setOptions` no longer exists in this release, so I made no change for it. `sigalgs` is already forwarded in the current `setSecureContext`; the fix did not add that forwarding there.

## Failing test
`parallel/test-https-agent-getname` fails, and it failed on both runs. The failure is at line 14, the empty-options case:
`actual: 'localhost:::::::::::::::::::'`, `expected: 'localhost::::::::::::::::::::::'`.

I did not run the tests for hunk 2 (server `setSecureContext`).

# Re-introduced bug: tls null option values rejected (nodejs/node#41170)

**Bug.** `tls.createSecureContext()` only treated `undefined` as "option not given" for many
options (pfx, sigalgs, dhparam, crl, sessionIdContext, ticketKeys, sessionTimeout,
privateKeyIdentifier, clientCertEngine). Passing `null` (as 3rd-party libs do) threw
ERR_INVALID_ARG_TYPE or otherwise misbehaved.

**Changes (lib/internal/tls/secure-context.js only)** – each undoes the matching fix hunk
(`x !== undefined && x !== null` -> `x !== undefined`):
- `sigalgs`, `privateKeyIdentifier`, `dhparam`, `crl`, `sessionIdContext`, `pfx`, the
  `clientCertEngine` else-if, `ticketKeys`, `sessionTimeout` guards.
- the per-pfx-entry `pass !== undefined && pass !== null` check -> `pass !== undefined`.
- passphrase/ciphers checks restored to `!= null` (semantically identical to the fixed form).
Not reverted: `privateKeyEngine === null` handling, error-message type lists, and the
key-array passphrase handling (already differs in today's code).

**Failing test.** parallel/test-tls-connect-secure-context (stable over repeated runs):
`TypeError [ERR_INVALID_ARG_TYPE]: The "options.sigalgs" property must be of type string. Received null`

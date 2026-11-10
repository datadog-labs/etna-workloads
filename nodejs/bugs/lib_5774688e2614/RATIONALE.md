# Re-introduced bug: overriding https.globalAgent is ignored

**Bug:** `https.request()` used the module-local `globalAgent` constant instead of
`module.exports.globalAgent`, so assigning `require('https').globalAgent = agent`
had no effect on subsequent requests.

## Hunks
1. `lib/https.js` (`request()`): `options._defaultAgent = module.exports.globalAgent;`
   -> `options._defaultAgent = globalAgent;`. Corresponds to the fix's https.js hunk
   (same line, re-expressed for today's code). Restores the old behaviour of always using the
   internal agent.

The `lib/http.js` hunk of the fix (getter/setter for `globalAgent`) was deliberately NOT
reverted: today's `setGlobalProxyFromEnv` relies on that setter, so reverting it would break
unrelated proxy functionality. The https hunk alone brings back the defect.

## Failing test
- `parallel/test-https-client-override-global-agent` -> `not ok` (stable over 2 runs; the
  assertion `agent.sockets.hasOwnProperty(name)` fails because the custom agent was not used).
- `parallel/test-http-client-override-global-agent` still passes.

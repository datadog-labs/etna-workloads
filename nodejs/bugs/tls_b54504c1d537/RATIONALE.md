# Re-introduced bug: tls server.addContext() ignores SecureContext objects

**Bug:** `server.addContext(servername, context)` always called `tls.createSecureContext(context)`, even when `context` was already a `tls.SecureContext`. Re-wrapping a SecureContext loses its key/cert/ca options, so the SNI context ends up with no valid credentials. Clients using that servername then see wrong or failing authorization.

**Hunk:** `lib/internal/tls/wrap.js`, `Server.prototype.addContext`. The code has moved from `lib/_tls_wrap.js` and now uses `.push` instead of `ArrayPrototypePush`. This corresponds to the fix's single implementation hunk in `lib/_tls_wrap.js`. I removed the `context instanceof common.SecureContext ? context : ...` check and restored the unconditional `this._contexts.push([re, tls.createSecureContext(context).context])`. That is the pre-fix behaviour.

**Failing test:** `parallel/test-tls-add-context` gives `not ok`. The failure is `AssertionError: Expected values to be strictly equal: false !== true` at test-tls-add-context.js:33 (`c.authorized`). I ran it twice and it failed both times.

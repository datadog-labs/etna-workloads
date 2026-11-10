# Re-introduced bug: ClientRequest.destroyed not set once request completes

Bug: `req.destroyed` stayed false after a request completed (keep-alive response ended, or socket closed),
including at 'close' time, so destroy()/abort() on a completed request was not a noop.

Hunks (lib/_http_client.js), reversals of the fix:
1. `socketCloseListener`: removed `req.destroyed = true;` (fix hunk 1 added it). 'close' is emitted with destroyed === false.
2. `responseKeepAlive`: removed `req.destroyed = true;` (fix hunk 2). Completed keep-alive requests are not marked destroyed, so a later destroy()/abort() is not a noop.
(The fix's other changes — moving `res.destroyed = true` — already differ in today's code, where it is set elsewhere; untouched.)

Failing tests: parallel/test-http-client-override-global-agent, parallel/test-http-client-agent-end-close-event
(assert.strictEqual(req.destroyed, true) fails: false !== true), parallel/test-http-keepalive-free
(same assertion in res 'end').

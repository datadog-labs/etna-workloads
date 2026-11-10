# Re-introduced bug: http double AbortSignal registration

**Bug:** `ClientRequest` registers the `signal` option itself (`addAbortSignal(signal, this)`), but also passed `signal` on to the agent / `net.createConnection`, so the socket registered a second abort listener on the same signal (two listeners instead of one).

**Hunk:** `lib/_http_client.js`: removed `delete optsWithoutSignal.signal;` after `addAbortSignal(signal, this)`. This corresponds to the fix's `optsWithoutSignal` hunks (which strip `signal` before `agent.addRequest`, `createConnection`, and `net.createConnection`). In today's code the copy `optsWithoutSignal` is built earlier, so removing the delete restores the old behaviour of forwarding signal.

**Failing tests:** parallel/test-http-client-abort-destroy, test-http-agent-abort-controller, test-https-abortcontroller. These fail on the `getEventListeners(signal, 'abort').length === 1` assertions, because the count is 2.

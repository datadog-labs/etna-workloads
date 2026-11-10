# Bug: http response.setTimeout() does nothing

`res.setTimeout()` on an `http.IncomingMessage` (client side) sets a socket timeout, but the response never emitted `'timeout'`, because nothing forwarded the socket's `'timeout'` event to the response. Callers' `res.on('timeout')` handlers never fire.

## Changes (all in lib/_http_client.js)
1. `socketOnData` (upgrade/CONNECT path): removed `socket.removeListener('timeout', responseOnTimeout)`. Corresponds to the fix hunk of the same name. Without the forwarder there is nothing to remove.
2. `parserOnIncomingClient`: removed `socket.on('timeout', responseOnTimeout)`. This is the core of the fix; it is what forwarded socket timeouts to the response.
3. `responseOnEnd`: removed `socket.removeListener('timeout', responseOnTimeout)`. This matches the fix hunk. The existing `if (socket)` guard is kept because today's code already has it.
4. Removed the `responseOnTimeout` function, which is now unused. It corresponds to the fix's added function.

## Failing tests
- `parallel/test-http-client-timeout-option-listeners` fails. The socket has one fewer `timeout` listener than the test expects (2 instead of 3).
- `parallel/test-http-client-response-timeout` never receives `res` `'timeout'`, so `common.mustCall` fails. The test run was still in progress when I wrote this.

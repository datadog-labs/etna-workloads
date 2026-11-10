# Re-introduced bug: ClientRequest unhandled socket errors (fe43bd8)

**Bug:** In `onSocketNT` (lib/_http_client.js), when a request is destroyed with an agent and no error, the socket was always handed back with `socket.emit('free')`, even if the socket was already destroyed (e.g. `createConnection` socket destroyed with an error). The destroyed socket's error then goes unhandled / is not routed to the request.

**Hunk (lib/_http_client.js, onSocketNT):** corresponds to the single implementation hunk of the fix. The fix nested the branches under `if (socket)` and added `&& !socket.destroyed` to the free condition, so destroyed sockets go through `socket.destroy()`/`finished()`. I restored the old shape: `if (!err && req.agent) { if (socket) { emit('free'); removeListener(...) } } else if (socket) { finished(socket.destroy(...)) ... }`, without the `!socket.destroyed` check. The rest of the current code (premature-close handling, listener removal) is kept.

**Failing test:** `parallel/test-http-client-abort3` — `not ok`, uncaught `Error: Oops` (emitted from the destroyed socket via emitErrorNT). Stable over 2 runs.

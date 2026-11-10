# Rationale

**Bug:** `socket.write(data, cb)` on a connecting socket that is destroyed before the connection is established never invokes `cb` (the write is parked waiting for a `connect` event that never comes).

**Hunks**
- `lib/net.js` `_writeGeneric`: removes the `once('close', onClose)` listener, the `onClose` function (which called `cb(new ERR_SOCKET_CLOSED_BEFORE_CONNECTION())`), and the `off('close', onClose)` in the connect handler. Corresponds to the fix's `_writeGeneric` hunk.
- `lib/net.js` import: removes the now-unused `ERR_SOCKET_CLOSED_BEFORE_CONNECTION` (fix's import hunk).
- `lib/internal/errors.js`: removes the `ERR_SOCKET_CLOSED_BEFORE_CONNECTION` definition (fix's errors.js hunk).

**Failing test:** `parallel/test-net-write-cb-on-destroy-before-connect` fails (`not ok`, exitcode 1) in two runs, since the write callback is never called (expectsError `mustCall` unmet).

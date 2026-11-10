# Re-introduced bug: nodejs/node#48771 (fix d8c00ad316e2, PR #61658)

## Bug

When `http.request()` is given a custom *synchronous* `lookup` (or a
`createConnection` that connects at once) and the resolved address fails
immediately, the socket error can be emitted before the HTTP client has an
error listener on the socket. An example of an immediate failure is an IP
rejected by `net.BlockList`, which gives `ERR_IP_BLOCKED`. In that case
`internalConnect()` calls `socket.destroy(err)` synchronously, and the stream
machinery emits `'error'` on the next tick. Before the fix, `ClientRequest`
attached `socketErrorListener` only in `tickOnSocket()`, which runs from
`onSocketNT` (also a `process.nextTick`, queued *after* the error emission).
So the socket's `'error'` was emitted with no listener: an unhandled
`'error'` event crashed the process, and `req.on('error')` never saw the error.

## How the code changed since the fix

The upstream fix deferred the `self.destroy(...)` calls in
`internalConnect`/`internalConnectMultiple` (lib/net.js) with
`process.nextTick(emitErrorAndDestroy, ...)`. In v26.13.0 that net.js deferral
is gone: those calls are plain `self.destroy(...)` again, and there is no
`emitErrorAndDestroy`. The same guarantee ("the HTTP client's error handler
is in place before a synchronous connect error is emitted") is now provided in
`lib/_http_client.js`. `ClientRequest.prototype.onSocket` attaches
`socketErrorListener` to the socket *synchronously*, before scheduling
`onSocketNT`. That is today's form of the fix, so the bug is re-introduced
there.

## Hunks

1. **`lib/_http_client.js`, `ClientRequest.prototype.onSocket`**: removed the
   synchronous `socket.on('error', socketErrorListener)`. It kept
   `socket._httpMessage = this`, because other later code depends on it, e.g.
   the keep-alive agent's `'free'` handler checked by
   `test-http-client-request-listeners-leak`.
   This corresponds to all the fix's `self.destroy(ex)` →
   `process.nextTick(emitErrorAndDestroy, ...)` hunks in `internalConnect`
   (bind error, `ERR_IP_BLOCKED`, connect error) and `internalConnectMultiple`
   (timeout / AggregateError), plus the `emitErrorAndDestroy` helper. Those
   hunks existed only to make the error come *after* the HTTP client's
   listener setup. With the listener attached early again, the ordering race
   is back: the error is emitted before any listener exists.
2. **`lib/_http_client.js`, `tickOnSocket`**: restored
   `socket.on('error', socketErrorListener)` where it was registered before the
   fix, i.e. only inside the next-tick `onSocketNT` → `tickOnSocket` path. This
   is the other half of re-expressing the same fix hunks. Normal (non-early)
   socket errors are still forwarded to the request, as they were before the
   fix.

## Failing test

`parallel/test-http-request-lookup-error-catchable` fails on every run
(checked 3+ times):

```
not ok 1 parallel/test-http-request-lookup-error-catchable
        throw er; // Unhandled 'error' event
    Error [ERR_IP_BLOCKED]: IP(127.0.0.1) is blocked by net.BlockList
      code: 'ERR_IP_BLOCKED'
```

Sanity check: `parallel/test-http-client-*`, `test-http-agent-*`,
`test-http-req*` and `test-net-blocklist*` pass, except the oracle test and
the unix-socket tests. Those fail with `listen EPERM` because the sandbox
blocks unix-socket listening, so they are unrelated to this change.

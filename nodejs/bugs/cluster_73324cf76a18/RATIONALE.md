# Re-introduced bug: cluster worker concurrent disconnect/destroy

Bug: In a cluster worker, calling `disconnect()` and/or `destroy()` concurrently sends several
`exitedAfterDisconnect` messages over IPC; once the channel closes, later sends fail with
`ERR_IPC_DISCONNECTED`.

Change (lib/internal/cluster/child.js, both hunks mirror the fix's hunks, adapted to today's code):
- `Worker.prototype.disconnect`: removed the `state` guard (`disconnecting`/`destroying`) and the
  `this.state = 'disconnecting'` assignment, so `_disconnect` runs on every call.
- `Worker.prototype.destroy`: removed the early return when `state === 'destroying'` and the
  `this.state = 'destroying'` assignment, so each call sends another `exitedAfterDisconnect`.

Failing test: parallel/test-cluster-concurrent-disconnect (fails stably, 2/2 runs) with
`ERR_IPC_DISCONNECTED` errors and then an `ERR_ASSERTION`.

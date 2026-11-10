# Re-introduced bug: net: fix socket._getpeername (9aef414b73c2)

**Bug.** `Socket.prototype._getpeername` stored an empty object in `this._peername` before calling `handle.getpeername()` and ignored the return value. If the first call failed (for example, the socket was not connected yet), the empty result stayed cached. `remoteAddress`, `remoteFamily` and `remotePort` then stayed `undefined` for the life of the socket, even after it connected.

**Change (lib/net.js, one hunk in `_getpeername`).**
- Corresponds to the fix's single implementation hunk. It restores `this._peername = {}; this._handle.getpeername(this._peername);` and drops the `const out` / `err` check. The error is again ignored and the result cached.
- A plain reversal was not enough. Today's code has `|| this.connecting` in the early-return guard, and the guard hid the bug because the test's first `remoteAddress` read happens while connecting. I also removed `|| this.connecting` from that guard, which is part of the same hunk of the same function. Without it, `getpeername` is called on the unconnected handle, fails, and the failure is cached.

**Failing test.** `parallel/test-net-remote-address` fails in 2 of 2 runs. It reads `remoteAddress` while connecting, then asserts it is defined after `connect`. The output shows an `AssertionError` from `strictEqual(socket.remoteAddress !== undefined, true)`. I saw only the start of the stack trace (`node:internal/assert/utils` ... `throw error`), so I haven't confirmed the exact message text.

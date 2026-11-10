# http: emit drain on socket takeover and avoid stale HWM reuse

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit dad9548fbc8bd8b88bedf233c309d3d799e75eee applied to v26.13.0 (clean).

Upstream commit message:

```
http: emit drain on socket takeover and avoid stale HWM reuse

When OutgoingMessage transitions from pre-socket buffering (Path B) to
socket-connected writing (Path A), the backpressure domain changes —
subsequent writes go directly to the socket, which enforces its own
backpressure via socket.write() return values.  The OM should emit
drain at this transition point to signal that its buffer is clear and
the caller can resume writing under the socket backpressure regime.

Previously, _flush() gated drain emission on writableLength === 0
which included socket.writableLength.  This conflated two independent
backpressure domains: the OM pre-socket buffer and the socket kernel
write queue.  When the socket had a higher writableHighWaterMark than
the OM (e.g. agent-reused socket from a prior request), the socket
was never backpressured and never emitted drain, causing a permanent
deadlock.

Additionally, avoid reusing a pooled socket in http.Agent when its
writableHighWaterMark differs from the request highWaterMark, so that
the user backpressure threshold is respected for the common case of
the built-in Agent.

Signed-off-by: Naman Trivedi <trivenay@amazon.com>
Fixes: https://github.com/nodejs/node/issues/64680
Refs: https://github.com/nodejs/node/pull/64653
Refs: https://github.com/nodejs/node/pull/62936
PR-URL: https://github.com/nodejs/node/pull/64991
Reviewed-By: Robert Nagy <ronagy@icloud.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
```

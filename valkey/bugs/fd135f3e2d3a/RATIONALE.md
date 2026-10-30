# Rationale

Changed only `tree/src/tracking.c`, in `trackingInvalidateKey()`.

Reverses the fix.patch hunk in tracking.c that added
`if (target == server.current_client) { schedule in tracking_pending_keys } else sendTrackingMessage(...)`.
9.0.7 has the same logic (guarded by `executing_command`), so I replaced it
with an unconditional `sendTrackingMessage()` to the target. This is the
pre-fix behaviour: the invalidation for the current client is emitted
immediately, i.e. before the command's reply and inside MULTI/EXEC or MGET replies.

Second path: 9.0.7 also defers pushes to the current client via
`shouldDeferPushMessage()`/`pending_push_messages` (networking.c), which
would hide the bug again. Rather than revert that PUBLISH-related
mechanism, the immediate send temporarily clears `server.executing_client`
so the push is written straight to the reply buffer. The pending-keys list,
`afterCommand()` and the other fix hunks are left in place (now unused for this path).

## Oracle failures
tests/unit/tracking.tcl: "hdel deliver invalidate message after response in the same connection",
"Tracking invalidation message is not interleaved with multiple keys response",
"... with transaction response", "Unblocked BLMOVE gets notification after response",
"Tracking invalidation message of eviction keys should be before response" and
the flushdb variant fail because the invalidate push arrives before/inside the reply.
The resulting protocol desync makes later cases in the file fail as well.

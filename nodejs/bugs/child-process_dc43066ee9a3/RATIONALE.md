# Rationale

**Bug:** With `serialization: 'advanced'`, the IPC write path did not keep a reference to the serialized Buffer while an async write was in flight. The Buffer could be garbage collected while libuv still used it, so large messages were corrupted or lost (nodejs/node#34797).

**Hunk 1** (`lib/internal/child_process/serialization.js`, `advanced.writeChannelMessage`): the fix stored the buffer in `req.buffer` when `streamBaseState[kLastWriteWasAsync]` was set. In today's code the buffer is `serializedMessage`, not the old `Buffer.concat` result. I removed the retention block and now return `channel.writeBuffer(...)` directly. This restores the pre-fix behaviour.

**Hunk 2** (same file): I removed the `streamBaseState, kLastWriteWasAsync` import from `stream_wrap`, which the fix added and which is now unused.

**Failing test:** `parallel/test-child-process-advanced-serialization-largebuffer` fails in two runs with: `Mismatched <anonymous> function calls. Expected exactly 4, actual 0.` The parent receives none of the 4 messages.

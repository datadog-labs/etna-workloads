# Re-introduced bug: blob.stream() hanging promises / no read-ahead

Bug: the pull() of the blob reader stream did not keep reading until EOS, an error, or
backpressure (desiredSize). Each pull consumed a single chunk and the stream did not keep
filling its queue, so readers did not get the expected flow (and pending pulls could be left
unresolved/mis-handled).

Change (lib/internal/blob.js, `readNext` in `createBlobReaderStream`): corresponds to the fix's
hunk that added the `readNext` loop with the `queueMicrotask`/`desiredSize` backpressure check
after `c.enqueue`. In today's code that is the `setImmediate(... desiredSize ... readNext(c))`
block; I replaced it with "shift the pending pull, resolve it, clear wakeup", i.e. the pre-fix
single-read-per-pull behaviour. No read-ahead occurs, so the stream's desiredSize stays 1 after a read.

Failing test: parallel/test-blob (fails stably in 2+ runs): "Mismatched noop function calls.
Expected exactly 1, actual 0." (the new-style stream tests with desiredSize/read loops never complete).

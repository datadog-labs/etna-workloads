# Rationale

**Bug:** A worker whose event loop cannot be created hit a hard `CHECK_EQ(uv_loop_init(&loop_), 0)` and aborted the process instead of emitting a catchable `ERR_WORKER_INIT_FAILED` error. Worker out-of-memory errors also carried no reason (message was just "Worker terminated due to reaching memory limit").

The fix's JS plumbing (custom_error_str_, onexit's third argument, ERR_WORKER_INIT_FAILED) has since been refactored into `Worker::Exit(code, error_code, error_message)`. That plumbing is kept. Only the two behaviours the fix changed are reverted.

## Hunks
1. `src/node_worker.cc`, `WorkerThreadData` constructor. This reverses the fix's `uv_loop_init` hunk. The error handling that called `w->Exit(..., "ERR_WORKER_INIT_FAILED", err_buf)` is replaced by `CHECK_EQ(uv_loop_init(&loop_), 0)`. A loop-creation failure is a hard assert again.
2. `lib/internal/errors.js`. This reverses the fix's errors.js hunk. The `ERR_WORKER_OUT_OF_MEMORY` message loses the `: %s` reason suffix. The reason passed from C++ ("JS heap out of memory") is therefore dropped from the error message.

## Failing test
`parallel/test-worker-resource-limits` fails with "not ok". The `error` event's message is `Worker terminated due to reaching memory limit` instead of `... limit: JS heap out of memory`, so `common.expectsError` throws ERR_INTERNAL_ASSERTION. I ran it twice and it failed both times.

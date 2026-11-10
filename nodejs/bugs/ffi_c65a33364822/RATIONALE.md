# ffi: do not abort when a Worker stops in a callback

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c65a33364822eca4915c66dea488a45f125bd86a applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: do not abort when a Worker stops in a callback

Stopping a Worker while it is running an FFI callback aborted the whole
process with "Callbacks cannot throw an exception". This happened on
worker.terminate(), on process.exit() inside the callback, and when the
main thread exited while the Worker was in a callback, since exit
terminates all Workers.

All three stop the Worker by terminating execution, and InvokeCallback
treated the termination as a thrown exception. Check HasTerminated()
first and return a zeroed result so the native caller can unwind.
Callbacks that throw still abort.

Signed-off-by: Trivikram Kamat <16024985+trivikr@users.noreply.github.com>
Assisted-by: claude:opus-5.5
PR-URL: https://github.com/nodejs/node/pull/66389
Fixes: https://github.com/nodejs/node/issues/66388
Reviewed-By: Daeyeon Jeong <daeyeon.dev@gmail.com>
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```

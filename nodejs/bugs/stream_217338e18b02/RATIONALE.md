# stream: fix Writable.toWeb() hang on synchronous drain

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 217338e18b02dd7179700694bc7eac3c6acf09e4 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix Writable.toWeb() hang on synchronous drain

A race condition in the Writable.toWeb() adapter caused the stream
to hang if the underlying Node.js Writable emitted a 'drain' event
synchronously during a write() call. This often happened when
highWaterMark was set to 0.

By checking writableNeedDrain immediately after a backpressured write,
the adapter now correctly detects if the stream has already drained,
resolving the backpressure promise instead of waiting indefinitely
for an event that has already occurred.

Fixes: https://github.com/nodejs/node/issues/61145
Signed-off-by: sangwook <rewq5991@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/61197
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```

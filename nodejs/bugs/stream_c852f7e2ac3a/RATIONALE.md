# Rationale

**Bug:** stream.pipeline destroying an http response (IncomingMessage) used `res.destroy(err)` instead of `res.req.abort()`. destroy(err) on the response propagates the error to the request, so an unexpected 'error' is emitted on the ClientRequest, and unlike abort() it does not dump buffered data.

**Change (lib/internal/streams/destroy.js, `destroyer`):** removed the `else if (isRequest(stream.req)) { stream.req.abort(); }` branch. This corresponds to the fix hunk adding `if (isRequest(stream.req)) return stream.req.abort();` (in today's code the logic lives in destroy.js's `destroyer`, called from pipeline.js). The `stream && ` null guard hunk is already inherent (`!stream` check) and the old `noop` req-error handler no longer exists, so no other hunks apply. Without the branch, responses fall to `stream.destroy(err)`, restoring the old behaviour.

**Failing test:** parallel/test-stream-pipeline now reports `not ok` (the new http response case: the request emits an unexpected 'error', hitting `common.mustNotCall()`).

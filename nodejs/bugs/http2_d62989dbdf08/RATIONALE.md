# http2: fix async context loss when trailers carry END_STREAM

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d62989dbdf08561ebd7d89535be7a0a3c806965d applied to v26.13.0 (clean).

Upstream commit message:

```
http2: fix async context loss when trailers carry END_STREAM

The previous fix (f67e45e070) wrapped header/response event dispatch in
reqAsync.runInAsyncScope(), but missed the stream.push(null) call that
triggers the 'end' event. When END_STREAM arrives on a trailing HEADERS
frame (as gRPC does), the 'end' event fires in the session's async
context instead of the request's context.

Wrap stream.push(null) at end-of-stream in reqAsync.runInAsyncScope()
so that the 'end' event preserves the correct AsyncLocalStorage context.

Refs: https://github.com/nodejs/node/pull/55460
Signed-off-by: Orgad Shaneh <orgad.shaneh@audiocodes.com>
PR-URL: https://github.com/nodejs/node/pull/63814
Reviewed-By: Stephen Belanger <admin@stephenbelanger.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```

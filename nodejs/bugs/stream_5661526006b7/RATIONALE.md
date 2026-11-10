# stream: fix ERR_INVALID_STATE when cancelling Readable.toWeb()

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 5661526006b7b0fa466ed0505b507a34bbe266ad applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix ERR_INVALID_STATE when cancelling Readable.toWeb()

When a web ReadableStream returned by Readable.toWeb() is cancelled
while the underlying Readable is actively producing data, a pending
onData callback can still fire after the controller has been closed
and attempt to enqueue a chunk, throwing ERR_INVALID_STATE.

Check wasCanceled in the onData handler and return early to avoid
calling controller.enqueue() on a closed controller.

Refs: https://github.com/nodejs/node/issues/54205
Signed-off-by: Richard Scarrott <riscarrott@googlemail.com>
PR-URL: https://github.com/nodejs/node/pull/62773
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```

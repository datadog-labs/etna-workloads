# stream: abort pending single-source merge reads

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 63e71195c5e548c92438f65dd5e340bf1958015a applied to v26.13.0 (clean).

Upstream commit message:

```
stream: abort pending single-source merge reads

Make the single-source merge path abort-aware so signal cancellation
rejects a pending read and closes the active source iterator.

Handle synchronous iterator return values when marking aborted cleanup
as handled.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64445
Fixes: https://github.com/nodejs/node/issues/64444
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
```

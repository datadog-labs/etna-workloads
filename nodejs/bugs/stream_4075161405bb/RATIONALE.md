# stream: destroy Duplex.from async function on early return

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4075161405bbe509c8cd9898d94a1e68fd763746 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: destroy Duplex.from async function on early return

When an AsyncFunction passed to Duplex.from() resolves without
consuming its input, tear down the duplex so pipeline() can finish
and destroy the upstream readable.

Fixes: https://github.com/nodejs/node/issues/55077
Assisted-by: Cursor
Signed-off-by: Aman Chadha <79802170+ac-mmi@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/65963
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
```

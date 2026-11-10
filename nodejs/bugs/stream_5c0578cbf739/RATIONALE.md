# stream: skip null output from stateful transforms

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 5c0578cbf739490e950df9406d675c8101cac692 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
stream: skip null output from stateful transforms

Treat null yielded by sync and async stateful transforms as no output,
consistent with transform normalization semantics.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64462
Fixes: https://github.com/nodejs/node/issues/64461
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
```

# stream: normalize fused stateless transform results

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 5b7d02e401794f6123b68e7f4453635f44aa5566 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: normalize fused stateless transform results

Normalize each stateless transform result before passing it to
the next transform in a fused run. This ensures that subsequent
transforms always receive Uint8Array[] batches in both synchronous
and asynchronous pipelines.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/65367
Fixes: https://github.com/nodejs/node/issues/65366
Reviewed-By: James M Snell <jasnell@gmail.com>
```

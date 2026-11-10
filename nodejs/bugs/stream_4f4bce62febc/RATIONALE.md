# stream: copy SAB-backed chunks in iter consumers

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4f4bce62febc2c2d929a72b4afe306cf776409d4 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
stream: copy SAB-backed chunks in iter consumers

Ensure bytes() copies single chunks backed by SharedArrayBuffer so
arrayBuffer() and arrayBufferSync() return ArrayBuffer instances as
specified.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: openai:gpt-5.5
PR-URL: https://github.com/nodejs/node/pull/64382
Fixes: https://github.com/nodejs/node/issues/64381
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Mattias Buelens <mattias@buelens.com>
```

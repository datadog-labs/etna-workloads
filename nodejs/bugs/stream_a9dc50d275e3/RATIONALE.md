# stream: reject pull on signal abort during flush

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit a9dc50d275e342b831ff7ee1f02d11c403a4c860 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: reject pull on signal abort during flush

An asynchronous transform can abort the pipeline while its final flush
resolves to null. With no final batch yielded, the pipeline previously
completed without observing the abort.

Check the signal after transform iteration completes so the consumer
rejects with the abort reason.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: codex:gpt-5.6-sol
PR-URL: https://github.com/nodejs/node/pull/65346
Fixes: https://github.com/nodejs/node/issues/65345
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```

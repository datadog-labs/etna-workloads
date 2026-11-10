# stream: validate fromWritable() options before cache

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit aa6913cc4a3bed9d6ea4b7f4661127edfa8bd984 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: validate fromWritable() options before cache

Validate options before returning a cached fromWritable() adapter so
invalid later options still throw.

Cache adapters by backpressure policy as well as Writable instance,
since the policy changes write behavior.

Fixes: https://github.com/nodejs/node/issues/63277

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: openai:gpt-5.5
PR-URL: https://github.com/nodejs/node/pull/63278
Fixes: https://github.com/nodejs/node/issues/63277
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
```

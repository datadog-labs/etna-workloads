# stream: reject push iterator.throw() with error

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 8e7a5e940e7524dc8625cca24d07d018dbd19329 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: reject push iterator.throw() with error

Keep the existing consumer cancellation side effects, but
reject the iterator.throw() call with the supplied error
instead of resolving with done: true.

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: openai:gpt-5.5
PR-URL: https://github.com/nodejs/node/pull/64380
Fixes: https://github.com/nodejs/node/issues/64378
Reviewed-By: James M Snell <jasnell@gmail.com>
```

# http: do not rely on the 'agentRemove' event

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 4a940aadfabc35be404da64e9ab7014a8cc71728 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
http: do not rely on the 'agentRemove' event

Do not use the `'agentRemove'` event to null `socket._httpMessage` as
that event is public and can be used to not keep a request in the agent.

PR-URL: https://github.com/nodejs/node/pull/20786
Fixes: https://github.com/nodejs/node/issues/20690
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Trivikram Kamat <trivikr.dev@gmail.com>
Reviewed-By: Anatoli Papirovski <apapirovski@mac.com>
```

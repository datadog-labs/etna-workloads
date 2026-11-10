# stream: observe abort while awaiting pipeTo source

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit d0b830b382d4c1e6c54565ec9db3ac08ca0b8a43 applied to v26.13.0 (fuzzy).

Upstream commit message:

```
stream: observe abort while awaiting pipeTo source

Use the abort-aware iterator wrapper in the no-transform pipeTo()
path so a pending source read does not block AbortSignal handling.

Fixes: https://github.com/nodejs/node/issues/64014

Signed-off-by: Kamat, Trivikram <16024985+trivikr@users.noreply.github.com>
Assisted-by: openai:gpt-5.5
PR-URL: https://github.com/nodejs/node/pull/64015
Fixes: https://github.com/nodejs/node/issues/64014
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```

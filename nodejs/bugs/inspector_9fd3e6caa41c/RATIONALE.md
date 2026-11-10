# inspector: fix crash when the IsolateData has no platform

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 9fd3e6caa41cf5bd804fff4a3582256e1c5684f1 applied to v26.13.0 (clean).

Upstream commit message:

```
inspector: fix crash when the IsolateData has no platform

An embedder that creates its IsolateData without a MultiIsolatePlatform
(allowed; node.h says only Workers need one) and keeps the inspector
segfaulted on the first `console.log()`, `console.time()` or profiler
use after a `node:inspector` session was connected: V8 calls the
inspector client's `currentTimeMS()` there, and
`NodeInspectorClient::currentTimeMS()` dereferenced
`isolate_data()->platform()` unconditionally.

Fall back to the wall clock when there is no platform, which is what
`NodePlatform::CurrentClockTimeMillis()` returns anyway.

Refs: https://github.com/nodejs/node/pull/21917
Signed-off-by: Shelley Vohr <shelley.vohr@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65818
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
```

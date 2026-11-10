# perf_hooks: fix truncation of monitorEventLoopDelay() resolution

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e06aa62cecb9b5db9ee84977c4ba6475de31f37c applied to v26.13.0 (clean).

Upstream commit message:

```
perf_hooks: fix truncation of monitorEventLoopDelay() resolution

`IntervalHistogram` stored the interval as `int32_t`, so a resolution
above 2^31 - 1 ms wrapped: `resolution: 2 ** 32 + 1` sampled every
millisecond.

Signed-off-by: James M Snell <jasnell@gmail.com>
Assisted-by: OpenCode
PR-URL: https://github.com/nodejs/node/pull/66115
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```

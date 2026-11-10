# perf_hooks: fix PerformanceObserver observer count leaks

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0bd9905959fabcaa6598eafcf46d5b189ac168d6 applied to v26.13.0 (clean).

Upstream commit message:

```
perf_hooks: fix PerformanceObserver observer count leaks

Observing the same entry type more than once on a PerformanceObserver,
through repeated `observe({ type })` calls or duplicates in
`entryTypes`, incremented the internal observer count each time, while
`disconnect()` decremented it only once per observed type. The counts
never returned to zero, so GC tracking stayed installed, and entries
for types such as `'http'` and `'dns'` kept being created after all
observers had disconnected.

Count each entry type at most once per observer.

Assisted-by: OpenCode
Signed-off-by: James M Snell <jasnell@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/66097
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```

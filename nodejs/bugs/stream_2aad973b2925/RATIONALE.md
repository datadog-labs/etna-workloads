# stream: resume flow when an errored pipe destination is removed

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2aad973b29257e54923a062af16cfd5cb995d3a8 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: resume flow when an errored pipe destination is removed

When a source is piped to multiple destinations and one destination
errors synchronously in `_write()`, `write()` returns false without
setting `needDrain` (since the "avoid unnecessary drain for sync
stream" change). The pipe cleanup only re-invoked the source's drain
handler when the destination still had `needDrain` set, so the errored
destination was never removed from the source's `awaitDrainWriters`
set. The source stayed paused forever and any remaining healthy
destination stopped receiving data.

Always invoke the drain handler during cleanup. `pipeOnDrain` only
removes this destination from the awaiting-drain set and resumes the
source once nothing else is awaiting a drain, so it is safe to call
unconditionally and no-ops when this destination was not awaiting a
drain.

Fixes: https://github.com/nodejs/node/issues/53185
Signed-off-by: Mahin Anowar <86069420+MahinAnowar@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/64310
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
```

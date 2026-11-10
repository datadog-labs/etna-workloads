# lib: fix AbortSignal.any() observed-composite leak

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 19b9c14d600cc5fe6cbe56791e79986e033e1b62 applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix AbortSignal.any() observed-composite leak

An observed composite signal (one with an `abort` listener) is added to
gcPersistentSignals so it stays alive long enough to fire. When one of
its sources aborted, the composite was marked aborted but never removed
from that set, so it was retained forever and its WeakRef was never
pruned from a long-lived source's kDependantSignals. That set therefore
grew without bound.

Drop each transitively-aborted dependent from gcPersistentSignals, the
same way the directly-aborted signal is already removed, so it can be
collected and its dependant entries pruned.

Fixes: https://github.com/nodejs/node/issues/64476
Signed-off-by: Paul Bouchon <mail@bitpshr.net>
PR-URL: https://github.com/nodejs/node/pull/64481
Reviewed-By: Chemi Atlow <chemi@atlow.co.il>
Reviewed-By: Edy Silva <edigleyssonsilva@gmail.com>
```

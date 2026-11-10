# Re-introduced bug: domain circular memory references (nodejs#23862)

**Bug:** `lib/domain.js` keeps an `asyncId -> domain` map (`pairing`). With strong values, a chain emitter -> resource -> async id => domain -> emitter cannot be seen by the GC, so the domain, resource and emitter leak.

**Changes (all in lib/domain.js, mirroring the fix's hunks in reverse):**
1. Removed the `kWeak` symbol and `WeakReference` import (fix hunk 1). The release imports it from `internal/util`, not `internalBinding('util')`.
2. `init`: `pairing.set(asyncId, process.domain)` instead of `process.domain[kWeak]`. The map holds the domain strongly again (fix hunk 2).
3. `before`/`after`: call `current.enter()` / `current.exit()` directly. The release's extra `incRef`/`decRef` calls are removed because they only make sense for weak references (fix hunk 2).
4. Constructor: removed `this[kWeak] = new WeakReference(this)` (fix hunk 3).

**Failing test:** `parallel/test-domain-async-id-map-leak` gives `not ok` on two runs. The `onGC` callbacks never fire, so `common.mustCall()` fails.

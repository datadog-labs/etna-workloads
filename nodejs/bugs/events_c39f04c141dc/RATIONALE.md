# Rationale

**Bug:** Weak EventTarget listeners were cleaned up on GC by calling `listener.remove()` on the Listener only. That unlinks the node but never decrements `root.size`, never deletes the empty event entry, and never calls `kRemoveListener`. GCed weak listeners therefore stay counted, so `MaxListenersExceededWarning` is emitted spuriously.

**Changes (all in lib/internal/event_target.js):**
- `weakListeners()` finalization callback: restored to `(listener) => listener.remove()`. Reverts the fix hunk that changed it to call `eventTarget.deref()?.[kRemoveWeakListenerHelper](...)`.
- `Listener` constructor: `registry.register(listener, this, this)` replaces the `{eventTarget: WeakRef, listener, eventType}` held value. Reverts the matching fix hunk.
- Removed the `kRemoveWeakListenerHelper` symbol and method. The fix added both, so reverting removes them.
- I left the `eventTarget`/`eventType` constructor parameters in place. They are now unused but harmless, and keeping them avoids touching every call site.

**Failing test:** `parallel/test-eventtarget-memoryleakwarning` fails with `Unexpected extra warning received: MaxListenersExceededWarning: Possible EventTarget memory leak detected. 3 foo listeners added to EventTarget. MaxListeners is 2.` The test failed on two consecutive runs. `parallel/test-eventtarget` still passes.

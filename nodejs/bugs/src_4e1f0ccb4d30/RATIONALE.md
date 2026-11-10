# Re-introduced bug: crash when lazy getter invoked in a vm context

**Bug:** `DefineLazyPropertiesGetter` (src/node_util.cc), the native accessor used by `defineLazyProperties`, has no JS function and so no creation context. When it is called from a vm context, `Realm::GetCurrent(info)` returns nullptr, and the getter dereferences it. The process crashes (SIGSEGV).

**Hunk (src/node_util.cc):** This corresponds to the fix's node_util.cc hunk. The fix derived the context from the receiver (`info.This()`, `HolderV2()` in this release) via `GetCreationContext()`, and then used `Realm::GetCurrent(context)`. I put back the old code: `Realm* realm = Realm::GetCurrent(info); isolate = realm->isolate(); context = isolate->GetCurrentContext();`. The receiver check and its `THROW_ERR_INVALID_INVOCATION` calls are gone. `ERR_INVALID_INVOCATION` in node_errors.h is left alone because it is harmless and the old code never used it.

**Failing test:** `parallel/test-vm-util-lazy-properties` crashes with exitcode -11 (SIGSEGV), severity: crashed, and TAP reports "not ok".

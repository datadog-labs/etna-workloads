# Blob @@toStringTag removal

**Bug:** `Blob.prototype` had no `Symbol.toStringTag`, so `Object.prototype.toString.call(new Blob([]))` gave `[object Object]` instead of `[object Blob]` (unlike browsers).

**Change (lib/internal/blob.js only):**
- Removed the `ObjectDefineProperty(Blob.prototype, SymbolToStringTag, {configurable: true, value: 'Blob'})` block. This matches the fix's added definition hunk. In today's code it sits before `ObjectDefineProperties(Blob.prototype, ...)`, and it also has `__proto__: null`.
- Removed the `ObjectDefineProperty` and `SymbolToStringTag` primordials imports, which are now unused. This matches the fix's import hunk.

**Failing test:** `parallel/test-blob` fails. The descriptor assertion gets `actual: undefined` where it expects `{configurable: true, enumerable: false, value: 'Blob', writable: false}`. It failed on both runs.

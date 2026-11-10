# Re-introduced bug: process lacks Symbol.toStringTag

**Bug:** `Object.prototype.toString.call(process)` returned `[object Object]` instead of `[object process]`, because `process` had no `Symbol.toStringTag` own property.

**Hunk:** `lib/internal/bootstrap/node.js`, `setupProcessObject()`. This corresponds to the fix's single implementation hunk, which added `Object.defineProperty(process, Symbol.toStringTag, {... value: 'process'})` after `EventEmitter.call(process)`. In today's code that call is `ObjectDefineProperty(process, SymbolToStringTag, {...})`, and I removed it. That restores the pre-fix behaviour.

**Failing test:** `es-module/test-esm-process` fails with `AssertionError: Expected values to be strictly equal: + '[object Object]' - '[object process]'`.

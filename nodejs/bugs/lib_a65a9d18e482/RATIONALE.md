# Rationale

**Bug:** `addBuiltinLibsToObject` lazily defines getters for builtin modules on the global object. On first access the getter deleted the property and redefined it. If user code had made the global non-configurable (e.g. `Object.defineProperty(global, "fs", { configurable: false })`), the `delete` fails (TypeError in strict code) or the `defineProperty` throws, so `fs` access throws instead of returning the module (nodejs/node#45336).

**Change** (`lib/internal/modules/helpers.js`; the file was `cjs/helpers.js` at fix time): in the getter, replaced the `try { ObjectDefineProperty(...) } catch {}` with the old `delete object[name]; ObjectDefineProperty(...)` sequence. This matches the single implementation hunk of the fix, reversed.

**Failing test:** `parallel/test-cli-eval` fails (not ok, both runs). The regression case `-p 'Object.defineProperty(global,"fs",{configurable:false}); fs === require("node:fs")'` now errors in the child process instead of printing `true`.

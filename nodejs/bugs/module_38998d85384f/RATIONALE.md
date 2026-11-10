# Re-introduced bug
Accessing `__esModule` on the exports of a module that is still loading (circular require) emits a
"Accessing non-existent property '__esModule' of module exports inside circular dependency" warning
when the other module is not a transpiled ES module, even though transpiled code does this routinely.

## Changes (lib/internal/modules/cjs/loader.js, CircularRequirePrototypeWarningProxy)
- `get` trap: removed `|| prop === '__esModule'` (and its comment) -> corresponds to the fix's `get` hunk.
- `getOwnPropertyDescriptor` trap: removed `|| prop === '__esModule'` -> corresponds to the fix's second hunk.
Together they restore the pre-fix behaviour: __esModule is warned about like any other missing key.

## Failing test
parallel/test-module-circular-dependency-warning: "not ok" (stable over 2 runs):
`Unexpected extra warning received: Warning: Accessing non-existent property '__esModule' of module exports inside circular dependency`

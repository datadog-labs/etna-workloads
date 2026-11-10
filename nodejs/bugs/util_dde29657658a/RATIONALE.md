# Rationale

**Bug:** `util.format('%s', obj)` (and `console.log`) decides via `hasBuiltInToString` whether to call `String(obj)` or `inspect` it. Before the fix, `Symbol.toPrimitive` was ignored, so an object with only a `[Symbol.toPrimitive]` method was treated as having a built-in `toString` and was inspected (`{ Symbol(Symbol.toPrimitive): [Function...] }`) instead of being converted via its toPrimitive.

**Change (lib/internal/util/inspect.js, `hasBuiltInToString`)**: corresponds to the fix's single hunk (the `typeof value[SymbolToPrimitive] === 'function'` check). The release had expanded this into toString/toPrimitive-aware own-property and prototype-chain logic, so I reverted the function to the pre-fix, toString-only logic (no-toString => built-in; own toString => not built-in; walk prototype chain for toString owner). I also removed the now-unused `SymbolToPrimitive` import (the fix's import hunk) and the unused `returnFalse` helper.

**Failing test:** parallel/test-util-format (stable over 2 runs):
`actual: '{ Symbol(Symbol.toPrimitive): [Function: [Symbol.toPrimitive]] }', expected: 'string representation'`

Input: `class A implements A` with a getter `x`, then quick info on `e.x` via the language service.
The self-referential implements makes the inherited-JSDoc lookup recurse into the same accessor.
Clean: prints `(property) A.x: string`. Injected: infinite recursion, caught and printed as `CRASH: RangeError`.

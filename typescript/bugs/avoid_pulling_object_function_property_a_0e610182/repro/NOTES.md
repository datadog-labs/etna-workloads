Input: `Test1 & {optional?: unknown}` with a `toString: null | 'string'` property, assigned from a spread of a `Test1` (issue #54345).
Clean: no errors. Injected: TS2322 because the intersection's toString is combined with Object's `() => string` augmentation (`"string" & (() => string)`).

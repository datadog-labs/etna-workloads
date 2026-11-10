a.js declares `/** @type {unique symbol} */ const foo = Symbol();` and uses `foo` as an index signature parameter type in a JSDoc @typedef, checked with tsc --checkJs.
Clean: reports TS1337 (index signature parameter type cannot be a literal type) at 5,18, since foo is recognised as a unique symbol.
Injected: the JSDoc `unique symbol` is not resolved to the declaration, so it reports TS1021 (index signature must have a type annotation) instead.

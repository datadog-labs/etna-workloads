# Rationale

Bug: util.inspect relied on the mutable `constructor` property of Object.prototype / Function.prototype. If it was tampered with (e.g. a getter returning the prototype), inspect produced wrong output such as `Object <[Object: null prototype] {}> {}` for `{}`, and functions on objects were mishandled.

Hunks (all in lib/internal/util/inspect.js):
1. `getConstructorName`: removed the `wellKnownPrototypes.get(obj)` check (fix hunk adding it) so the name again comes only from the own `constructor` descriptor. The `wellKnownPrototypes` map definition is left in place (harmless, unused).
2. `formatRaw`: moved the `typeof value === 'function'` branch back after the `constructor === 'Object'` branch (reverse of the fix's reordering), so a function whose constructor name resolves to 'Object' is formatted as a plain object.

Failing test: parallel/test-util-inspect (stable over repeated runs):
AssertionError: Expected values to be strictly equal: actual 'Object <[Object: null prototype] {}> {}' expected '{}' (test-util-inspect.js:3944).

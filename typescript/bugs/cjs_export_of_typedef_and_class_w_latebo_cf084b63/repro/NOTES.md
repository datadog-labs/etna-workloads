index.js requires a CJS module whose `module.exports = LazySet` class has a late-bound `[Symbol.iterator]` member and a JSDoc @typedef.
Clean: only the expected TS2322 error for `undefined`.
Injected: extra TS2345 on `stringSet.addAll(stringSet)` ('import("LazySet")' not assignable to 'import("LazySet")', missing '[Symbol.iterator]').

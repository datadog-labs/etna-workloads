Input spreads a Set<number> into a generic rest-only signature `f<T extends unknown[]>(...args: T)`, then assigns the result to a string to expose the inferred type.
Clean: iterable is converted to an array, so T is `number[]` and the error reports "number[]" not assignable to string.
Injected: the Set is not iterated, so the inferred type/diagnostics differ (a spread-argument error or a different T).

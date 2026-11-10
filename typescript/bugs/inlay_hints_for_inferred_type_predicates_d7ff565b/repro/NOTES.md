Input: `function isString(x: unknown) { return typeof x === "string"; }` with return-type inlay hints enabled via the language service.
Clean: the hint is the inferred type predicate (`: x is string`).
Injected: the predicate is ignored and the hint is the plain return type (`: boolean`).

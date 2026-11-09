Input calls a union of two function types whose rest parameters are tuple types (`...args: [a: string|number, b: number|boolean]`), so the combined union signature has a rest parameter.
Clean: `test1(42, [true])` reports an error about the argument `boolean[]`/element type being not assignable to `boolean | string`-style parameter.
Injected: the combined signature loses HasRestParameter, so the diagnostic text differs (argument treated as a tuple/rest incorrectly).

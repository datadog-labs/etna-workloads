Input calls a generic helper (`createTransform`) on a nested generic arrow function that closes over a type parameter `P`, twice with different `P` arguments (`{a:1}` then `{foo:'bar'}`).
The declaration emit prints the inferred types of both exports.
Clean: `addP3_other` is `... I & I2 & { foo: string; }`. Injected: it wrongly reuses a cached instantiation and prints `{ a: number; }`.

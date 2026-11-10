Input: a generic function returns `createTransform(m)` where `m` is a generic local arrow function capturing outer type parameter `P`; it is called with `{ foo: 1 }`.
Emitted .d.ts shows the type of `addP2`/`added2`.
Clean: `<I>(from: I) => I & { foo: number }`. Injected: leaks the type parameter, `I & P`.

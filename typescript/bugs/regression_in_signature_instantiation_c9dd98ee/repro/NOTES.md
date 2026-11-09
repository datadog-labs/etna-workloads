Input: calls generic `f(g)` where `g` is `<T extends unknown>(x: {foo: T}) => unknown`, then indexes `FirstParameter<typeof h>["foo"]`.
Clean: no diagnostics.
Injected: error TS2536 (Type '"foo"' cannot be used to index type ...), since signature instantiation uses the wrong type parameters for the mapper.

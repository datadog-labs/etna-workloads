Input: generator `f(): Generator<string, void, unknown>` doing `const x2: number = yield* g()` with generic `g<T,U,V>(): Generator<T,U,V>`.
Clean: the contextual TReturn is not used to infer the `yield*` type, so no diagnostic (exit 0).
Injected: the contextual type is the function's return type, so U is inferred as void and it reports TS2322 "Type 'void' is not assignable to type 'number'" (exit 2).

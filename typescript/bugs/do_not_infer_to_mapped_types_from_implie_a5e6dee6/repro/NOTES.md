Input: the slimmed-down test from #52629. A generic `setupImages<R extends ImageHolder<K>, K extends string>` is called, and its result is destructured with an object rest binding (`const { prepare, ...rest } = ...`).
Clean: compiles with no errors.
Injected: the rest binding's implied index signature is used to infer K, so K becomes `string`. This gives error TS2345 ("Index signature for type 'string' is missing in type 'TestInterface'").

Input: a generic function with a local interface `NumArray<T extends number> extends Array<T>` and a self-referential local type alias `X = NumArray<X extends {} ? number : number>`.
Clean tsc reports the circular type-argument diagnostics normally.
Injected tsc drops the outer type parameters from the error-fallback type arguments, so the diagnostics/behaviour differ (no longer matches the expected output).

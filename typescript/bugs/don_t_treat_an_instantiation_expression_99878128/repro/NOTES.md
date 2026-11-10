input.ts assigns to an instantiation expression (`getValue<number> = () => 1234;`).
Clean tsc reports an error (invalid assignment target); the injected build treats the
instantiation expression as a type assertion in skipOuterExpressions and reports no/different diagnostics.

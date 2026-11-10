Input is the HKT pattern from #53970: `Apply<F, A>` over a TypeLambda, `map(typeClass)(a, _ => _)`, then `const bad: string = x2`.
Clean: x2 is inferred as `T<number>` and the error reads "Type 'T<number>' is not assignable to type 'string'".
Injected: the HKT type is not reduced, so x2 is `T<unknown>` and the error message says so.

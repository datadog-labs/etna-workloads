Input: the `homomorphicMappedTypeWithNonHomomorphicInstantiationSpreadable1` test. A homomorphic mapped type `HandleOptions<T[K]>` is spread into a tuple (`[...HandleOptions<T[K]>]`), where `T extends Record<PropertyKey, readonly any[]>`.
Clean: tsc reports no errors.
Injected: the apparent type uses the type parameter's constraint instead of the modifiers type's base constraint. tsc reports `error TS2574: A rest element type must be an array type.` at input.ts(12,19).

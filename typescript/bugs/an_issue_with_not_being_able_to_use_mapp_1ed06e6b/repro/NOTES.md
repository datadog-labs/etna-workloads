input.ts declares a generic function whose rest parameter type is a homomorphic mapped type over `T extends [number] | [string]`.
Clean tsc accepts it (exit 0). Injected tsc reports TS2370 "A rest parameter must be of an array type" because the union-of-tuples constraint is no longer treated as array-like.

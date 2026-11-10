Calls `test1<const T>(obj: { [K in keyof T]: T[K] })` with a nested object literal (reverse mapped type inference) and forces a type error to print the inferred type.
Clean: inferred T is fully readonly (`readonly prop`, `readonly nested`).
Injected: the reverse mapped type is not treated as const, so top-level `prop`/`nested` lose `readonly` (only the inner `nestedProp` is readonly).

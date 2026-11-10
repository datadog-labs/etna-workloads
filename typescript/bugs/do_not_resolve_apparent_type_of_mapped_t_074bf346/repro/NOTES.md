Declares a generic function whose mapped type `{[K in keyof TTypes]: ...}` is homomorphic over a type parameter
constrained to a readonly tuple (`readonly [T, ...T[]]`), and uses `TTarget[TTypes[K]]` inside it.
Clean: no errors. Injected: error TS2536 "Type 'TTypes[K]' cannot be used to index type 'TTarget'"
(the injected check only treats array constraints, not tuples, as having numeric keys).

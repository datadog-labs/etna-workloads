Input: a generic function `f1<T extends A | B>(t: T, x: A | B)` returning the array `[t, x]`, where `A` and `B` are object types.
Declaration emit prints the inferred return type.
Clean: `(A | B)[]` (T is removed by subtype reduction against the union `A | B`).
Injected: `(A | B | T)[]`, because the union-constraint type-parameter check is missing.

Input: a mapped tuple type with a conditional (`Tuple[Key] extends Tuple[number] ? ...`) used as the rest parameter of a generic function, and its result is assigned to `[string, number]`.
Clean: no errors (Tuple is inferred as [string, number]).
Injected: error TS2322, `Type '[unknown, unknown]' is not assignable to type '[string, number]'`, because getActualTypeVariable doesn't unwrap nested substitution types.

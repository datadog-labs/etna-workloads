Input: `declare const a: string[] | [string]; const f = a.every;` — the type of `a.every` is a union of two identical generic signature sets (`<S extends string>`).
The script prints `checker.typeToString` of `f` with the GenerateNamesForShadowedTypeParams flag and a source-file enclosing declaration.
Clean: both union members print `<S extends string>`. Injected: the second member is renamed `S_1` (type parameter scope entered after type parameters are serialized).

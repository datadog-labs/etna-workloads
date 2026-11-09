Input: `function f(x: unknown) { return typeof x === "string"; }` (inferred type predicate), run through the language service "Infer function return type" refactor (getEditsForRefactor).
Clean: inserts `: x is string` as the return type.
Injected: inserts `: boolean`, losing the type predicate.

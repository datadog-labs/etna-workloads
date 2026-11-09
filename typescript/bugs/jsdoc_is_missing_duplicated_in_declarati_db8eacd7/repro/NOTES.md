Input: a function returning a class expression whose method `foo` has two overloads with different JSDoc comments; emits only declarations.
Clean: each overload in the .d.ts keeps its own JSDoc (second has `@deprecated ... comment 2`).
Injected: the second overload gets the first overload's comment (`comment 1`) instead.

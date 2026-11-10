Input: a class with the `accessor` modifier on a method, getter and constructor (invalid placements), compiled with `--target es2017`.
Clean: tsc reports the grammar errors and emits JS normally.
Injected: the classFields transform hits `Debug.fail("Use `modifierVisitor` instead.")` on the stray `accessor` keyword, so tsc crashes.

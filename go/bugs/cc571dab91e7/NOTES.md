repro.sh compiles two functions that just `return a` into a named array result
(`[2]int` and `[4]int`) and prints each function's code size and MOVUPS count.

Clean: fa has 2 MOVUPS (1 load + 1 store), fb has 4 (2 pairs).
Buggy: the "self move to output parameter" check in expand_calls.go requires
matching memory args, so the copy is emitted twice: fa has 4, fb has 8, and the
code size roughly doubles. Behavior is unchanged; only code quality differs
(this is what test/codegen/issue74788.go checks).

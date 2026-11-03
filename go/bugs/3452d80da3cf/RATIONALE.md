# Rationale

Hunk reversed: `src/cmd/compile/internal/walk/range.go`, `arrayClear`. The fix wrapped the
final-value assignment `i = len(a) - 1` in `typecheck.Conv(..., nrange.Key.Type())`. In go1.27.3
the code has the same shape, except that it uses `ln` instead of a fresh `OLEN` node. I removed
the `typecheck.Conv` wrapper, which restores the pre-fix untyped-int assignment.

When the range key has a named type (`type T int`), the assignment is `T = int`. The compiler
then reports a type error.

Oracle: `Test/fixedbugs/issue73491.go` fails with
`cannot use .autotmp_2 - 1 (type int) as type T in assignment`. `TestShouldTest` still passes.

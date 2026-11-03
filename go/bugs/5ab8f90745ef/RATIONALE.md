# Rationale

Changed `tree/src/cmd/compile/internal/types2/conversions.go`, `operand.convertibleTo`
(go/types is outside src/cmd/compile, so only the types2 hunk is reverted).

- Hunk 1 of the fix added `origT := T`, `V := Unalias(x.typ())` and `T = Unalias(T)`.
  Reverted to `V := x.typ()` with T left as passed. Alias types are therefore no
  longer unwrapped, so the `V.(*TypeParam)` / `T.(*TypeParam)` assertions and the
  `V.(*Pointer)` / `T.(*Pointer)` assertions miss when V or T is an alias.
- Hunk 2 of the fix changed the error to print `origT`. Reverted to print `T`, which
  is the pre-fix code and equivalent now that T is no longer reassigned.

Oracle cases that fail: `TestFixedbugs` and `TestFixedbugs/issue67547.go` in
cmd/compile/internal/types2. The new cases in that file (conversions through an
alias of a type parameter, and `(*T)(p)` with `A = *S`) are wrongly rejected.

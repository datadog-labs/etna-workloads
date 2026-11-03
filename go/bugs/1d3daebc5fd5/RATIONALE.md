# Rationale

Bug: go.dev/issue/60564. Interface unification did not look under defined (named) interfaces when one type was named and the other a literal interface, so `f5(x)` with `x interface{m(int); n()}` against `I[T]` failed inference.

All changes are in `src/cmd/compile/internal/types2/unify.go`. On go1.27.3 the fix's code had been refactored into `asInterface`.

1. In `nify`, the `enableInterfaceInference && mode&exact == 0` block: `xi := asInterface(x)` / `yi := asInterface(y)` is replaced by `xi, _ := Unalias(x).(*Interface)` / `yi, _ := Unalias(y).(*Interface)`. This reverses the hunk that introduced `under(x).(*Interface)` (skipping type parameters). It restores the pre-fix lookup, which only recognised literal interfaces. `Unalias` is today's equivalent of the old plain `x.(*Interface)`. `asInterface` is left in place, now unused by this block.
2. In the `*Named` case of the switch, the removed block is restored. It does interface unification for named x/y when both are not exact. This reverses the hunk that removed it, and is the old path that picked "interface vs non-interface" for a named interface against a literal one.

The go/types copy is generated from types2, and the task is limited to cmd/compile, so it is not touched.

## Oracle failures
`TestFixedbugs/issue60562.go` (and so `TestFixedbugs`) fails. The testdata has `f5(x)` with no expected error, but the inference now reports "type interface{m(int); n()} of x does not match inferred type I[int] for I[T]".

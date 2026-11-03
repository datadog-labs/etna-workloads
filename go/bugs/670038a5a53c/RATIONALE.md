# Rationale

## Hunk 1 — `src/cmd/compile/internal/rangefunc/rewrite.go` (`bodyFunc`)
Reverses the fix hunk directly: the synthesized body closure's signature is built with
`false` instead of `ftyp.Variadic()`, so it loses the variadic bit of the yield function type.

## Hunk 2 — `src/cmd/compile/internal/types2/range.go` (`rangeKeyVal`)
Reversing hunk 1 alone does not bring the bug back, because go1.27.3 also has a second fix
for the same issue (#78314, commit "go/types, types2: in range-over-func, the yield function
cannot be variadic"). It rejects a variadic yield func in the type checker, so the rewriter never
sees one. I removed that `case cb.Variadic():` check, restoring the earlier behaviour in which
a variadic yield func is accepted and reaches the rangefunc rewrite.

## Oracle failure
`test/fixedbugs/issue78314.go` (`Test/fixedbugs/issue78314.go`) fails. The compiler now emits
"internal compiler error: func(#p1 int, #p2 []string) (#r bool) is not assignable to
func(int, ...string) bool" for `for range (func(func(int, ...string) bool))(nil)`, instead of
the expected "cannot be variadic" error. The ICE comes from the lost variadic bit on the closure.

# Reintroduce go.dev/issue/60556 (inexact unification of constraint method signatures)

## Changes (all in src/cmd/compile/internal/types2)

1. `infer.go` (hasAllMethods call in `infer`): the equivalence callback passed
   for constraint methods is `u.unify(x, y, 0)` again instead of
   `u.unify(x, y, exact)`. Reverses the fix's one-line change in
   `src/cmd/compile/internal/types2/infer.go` (go/types is not part of the tree here).
   Same code, only renamed (`missingMethod` -> `hasAllMethods`).

2. `unify.go` (interface-vs-interface method comparison, `u.nify(xm.typ, ym.typ, ...)`):
   passes `mode` instead of `exact`. Reverting hunk 1 alone does not bring the bug
   back in go1.27.3, because this later code forces `exact` for the method
   signatures once an interface pair is compared, which masks the inexact top-level
   mode. Same defect (inexact mode leaking into method-signature unification),
   so I reverted that second path too. The one-line cycle guard (`ifacePair`) does
   not stop the recursion since `p` is nil after the search loop.

## Oracle failures
`TestFixedbugs/issue60556.go` (the fix's test) fails: `f(S[int]{})` with
`T I[E]`, `m(I[T])` recurses endlessly (I[int] vs I[E] -> methods -> I[int] vs I[E]...),
giving a stack overflow crash of the types2 test binary. Other TestFixedbugs and
dependent cases fail because the crash kills the test process (165 of 592 reported).

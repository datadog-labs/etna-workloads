# Rationale

Changed: `src/cmd/compile/internal/types2/unify.go` (the `go/types` copy is generated and outside scope).

In go1.27.3 the interface-inference logic moved out of `case *Named` into an earlier block
(`if u.enableInterfaceInference && mode&exact == 0`). Interface pairs are handled there with
method-based unification, so the fix's `*Named` hunk cannot be reversed directly.

Hunk reversed: the removed `if sameOrig { unify xargs/yargs; return true }` branch for two
defined interfaces with identical origin. I re-added it at the start of the `xi != nil && yi != nil`
case of the inexact-interface block, using `identicalOrigin`. It unifies the type arguments instead
of the methods. A type parameter unused in the methods therefore gets inferred from the argument's
type argument (the pre-fix behaviour).

Failing oracle cases (types2 TestFixedbugs):
- issue60377.go: `g(x)` with `x T1[int]` infers P=int instead of reporting "cannot infer P".
- issue49541.go: `X(Interface[...](Impl{}))` wrongly infers Q instead of "cannot infer Q".
The test/fixedbugs/issue53309.go and test/typeparam/issue53762.go cases still pass, because
they only add an explicit type argument.

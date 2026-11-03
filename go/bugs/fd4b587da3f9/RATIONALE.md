# Rationale

The fix (CL 331569) added a guard in typecheck's `errorDetails` so that the "have/want"
detail was suppressed when a `...` argument was not a slice. The old typechecker is gone;
the equivalent code in go1.27.3 is `typesSummary` in
`src/cmd/compile/internal/types2/assignments.go`, which builds the "have (...)" text for
the "not enough arguments in call" error (`hasDots` == the old `isddd`).

Change: in the `hasDots` case, `typesSummary` now assumes the last argument's underlying
type is a slice (`t.Underlying().(*Slice).elem`) and panics otherwise. This restores the
pre-fix assumption (pre-fix `fmtSignature` required the `...` argument to be a slice)
without the guard that fixed bug #46957.

Oracle: test/fixedbugs/issue46957.go (`f(nil...)`) fails: the compiler panics with a
type-assertion failure instead of reporting "not enough arguments in call to f".

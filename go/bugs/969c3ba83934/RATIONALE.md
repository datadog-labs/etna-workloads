# Rationale

## Change
`src/cmd/compile/internal/types2/unify.go`, `unifier.nify`: the condition for
continuing unification with the underlying type of a defined type was changed
from `isTypeLit(x)` back to `!hasName(x)`.

Reverses the fix's hunk in `nify` (`if ny, _ := y.(*Named); ny != nil && isTypeLit(x)`
replacing `!hasName(x)`). `hasName` is true for basic types, so a defined type
(e.g. `type myInt int`) is no longer matched via its underlying type against a
basic type. Today's extra conditions (`mode&exact == 0`, interface inference)
are unchanged.

The other hunks of the fix (infer.go reporting an error on unify failure, the
unbound type-parameter core-type handling) are still in their fixed form in
go1.27.3 and were left alone; they are not needed to bring the bug back.

## Failing oracle cases
TestExamples (functions.go), TestFixedbugs (issue49179.go, issue51229.go,
issue53650.go, issue67872.go), TestStdTest, TestStdlib: type inference now fails
where a defined type must unify with a basic core type (go.dev/issue/53650
pattern), producing spurious errors.

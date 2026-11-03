# Rationale (issue 61879)

File changed: tree/src/cmd/compile/internal/types2/unify.go (go/types is outside scope).

The fix replaced `emode` with `exact` in three places where interface method
signatures (and interface-literal method lists) are unified. I reverted all three:
1. two-interface case: `u.nify(xm.typ, ym.typ, emode, p)`
2. one-interface case: `u.nify(xm.typ, ym.typ, emode, p)` (go1.27.3 also has a generic-method check, kept)
3. `*Interface` case in the switch: `u.nify(f.typ, g.typ, emode, q)`

Sites 1 and 2 sit before the original `emode` declaration, so I moved that
declaration (unchanged) up above the interface-inference block.

Oracle: TestFixedbugs/issue61879.go fails with a panic in the unifier (recursive
interface `Interface[T]` method signature unified inexactly); the panic trace
aborts the package test run, so many other cases in the package fail as well.

# Rationale

Go 1.27.3 has no stencil.go; generics use unified IR (noder/reader.go). The
analogue of the fix (conversions between interfaces under shape types, nonempty
to nonempty/empty, must go through the runtime/itab path and not be a no-op) is
in `reader.go` exprConvert: conversions between non-identical, non-empty
interfaces that typecheck mistakenly folds to OCONVNOP because of shape types
are forced to OCONVIFACE.

## Change
`src/cmd/compile/internal/noder/reader.go`: removed the `if !identical { ... n.SetOp(ir.OCONVIFACE) }`
block (replaced with `_ = identical`). This reverts to the pre-fix behaviour in which
an interface-to-interface conversion in a shaped function isn't treated as a real
conversion (no convI2I / itab update), the defect fixed by "fix stenciling of
conversions between interfaces" (fix hunks in convertUsingDictionary / subst.node
that route interface->interface conversions via CONVIFACE/convI2I).

## Oracle
`test/typeparam/eface.go` fails: "test 5/6/7/8 failed" (exactly the checks the fix
re-enabled: h[int](myint(5)) etc., nonempty-interface conversions in generic code).
The issue47925*.go cases still pass in this tree.

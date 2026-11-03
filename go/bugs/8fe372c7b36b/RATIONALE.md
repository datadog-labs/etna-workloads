# Rationale

Change: `src/cmd/compile/internal/inline/inl.go`, `hairyVisitor.doNode`.

- Reverses the `inl.go` hunk of the fix, which moved OCALLPART out of the list of
  non-inlinable ops. In go1.27.3 OCALLPART is `ir.OMETHVALUE`. It is again added to the
  `case ir.OGO, ir.ODEFER, ir.OTAILCALL` group, so it sets `reason = "unhandled op METHVALUE"`
  and the function is not inlinable. I removed it from the `OMETHVALUE, OSLICELIT` budget case
  because that case is now unreachable for it.
- The other hunks (iexport/iimport, typechecking the `-fm` wrapper body, `inlcopy`) have no
  counterpart that is still needed. Export of method values is now done by unified IR.

Oracle: `Test/inline.go` fails. The errors are `missing error "can inline getMeth"`,
`"can inline ii"`, `"inlining call to getMeth"` and `"t1.meth does not escape"`. These are the
cases the fix's test (issue 18493) added. `TestShouldTest` passes.

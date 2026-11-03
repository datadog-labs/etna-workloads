# Rationale: static array initialization laid out with the wrong context (#61730)

Fix hunk (walk/complit.go, `anylit`): for an `OARRAYLIT` with >4 elements the
static pass was run with `inNonInitFunction` instead of `inInitFunction`.
That context makes nested slice literals be built as static slices
(`slicelit` -> `staticdata.InitSlice`), so a dynamic element such as `&x`
(a stack address) is stored into a global static array.

go1.27.3 had already dropped the `initContext` parameter (every caller passed
`inInitFunction`), so the one-line hunk cannot be reversed directly. I restored
the parameter and the `inNonInitFunction` handling that the fix's pre-image relied on, all in
`src/cmd/compile/internal/walk/`:

* `complit.go` `anylit`: restored `ctxt := inInitFunction; if n.Op()==ir.OARRAYLIT { ctxt = inNonInitFunction }`
  and `fixedlit(ctxt, initKindStatic, ...)`. This is the reversed fix hunk.
* `complit.go`: re-added `type initContext` / `inInitFunction` / `inNonInitFunction`,
  the `ctxt` parameter on `fixedlit` and `slicelit`, the OSLICELIT condition in `fixedlit`
  (`kind==Static && ctxt==inNonInitFunction || kind==Dynamic && ctxt==inInitFunction`,
  with the `sinit`/orderBlock handling for issue 52673), and the `ctxt == inNonInitFunction`
  branch at the top of `slicelit` (static array + `InitSlice`). Without these, passing
  `inNonInitFunction` would have no effect, so the bug could not recur.
  The old code is as in go1.24's complit.go.
* `order.go`: the one other `fixedlit` call just gets the extra `inInitFunction` argument.
* All other callers pass `inInitFunction`, so only the array-literal static path changes behaviour.

## Oracle
`test/codegen/slices.go` (`Issue61730`) fails: `codegen/slices.go:463: linux/amd64/v4:
wrong opcode found: ^MOVQ .*stmp_`. The compiler emits `MOVQ AX, stmp_N(SB)` storing the
address of a stack temporary into a static global. `TestShouldTest` still passes.

# Rationale

Fix (issue #51509, `type T T.x` crashed): `Checker.selector` got the `def` type being declared and reported a cycle when the selector operand was that type.

In go1.27.3 `selector` no longer takes `def` (it takes `wantType`), and the same case is covered by a different path: after `check.exprOrType(x, e.X, false)` in `types2/call.go`, `selector` calls `check.isComplete(x.typ())`. That call finds `T` on `objPath` and reports the cycle via `cycleError`. It replaces the fix's `case typexpr: if def != nil && x.typ == def { cycleError; goto Error }`.

## Change
`src/cmd/compile/internal/types2/call.go`: removed the `isComplete` check ("We cannot select on an incomplete type") in `selector`. This restores the pre-fix behaviour, where nothing detects the cycle for `type T T.x`, so selection runs on the not-yet-complete type being declared.

## Oracle
Running `./check.sh`, the types2 test binary crashes with a panic in `Config.Check` during `TestCheck`. This is the crash the fix guards against. Because it is a panic, 454 of 592 oracle cases fail. That includes `TestCheck/cycles*.go` and the `issue51509`-style `T.x` case.

I did not inspect the head of the panic message. Only the tail of the stack was captured.

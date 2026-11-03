# Rationale

Fix hunk reversed: types2/call.go `funcInst` (the go/types hunk has no counterpart here, only cmd/compile is in scope).
The fix chose the version-error position as `inst.Pos()` if `inst != nil`, else `pos`.
In go1.27.3 this is `instErrPos`, passed to `verifyVersionf`. I restored the pre-fix
behaviour: when `allowVersion(go1_18)` fails, the error is reported at `inst.Pos()` unconditionally.
With reverse type inference (`var v func(int) = f`) `inst` is nil, so `-lang=go1.17` gives a nil dereference panic.
`instErrPos` is kept for the later go1.21 check (unrelated to this fix).

Failing oracle: `TestFixedbugs/issue59639.go` panics (nil pointer dereference in funcInst);
the panic aborts the test binary, so other cases in the package fail too.

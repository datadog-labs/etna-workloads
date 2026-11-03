# Rationale

Fix hunk: `ir.CaptureName` fataled with "misuse of CaptureName on closure variable" for any closure variable, and the fix exempted `.dict` (capturing a dictionary closure variable is ok).

In go1.27.3 `CaptureName` no longer exists; closure capture goes through `ir.NewClosureVar` (called from `reader.funcLit` in noder/reader.go, which captures the enclosing `.dict` param, itself a closure var in nested closures). I re-added the pre-fix fatal check there, restricted to the case the fix un-blocked (the `.dict` closure var): `src/cmd/compile/internal/ir/name.go`, `NewClosureVar`.

Effect: any closure nested inside a closure within a generic function ICEs ("misuse of NewClosureVar on closure variable: .dict"). This also breaks building std packages that use such code (crypto/internal/fips140/hmac, sync.OnceFunc), so testdir build fails.

Oracle: issue47684.go, 47684b.go, 47684c.go (nested closures in generic funcs) fail with the compiler ICE.

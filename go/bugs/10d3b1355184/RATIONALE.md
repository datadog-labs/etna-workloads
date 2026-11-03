# Rationale

Fix (49524): stenciled generic function bodies that were empty came out with
`len(Body)==0`, which `enqueueFunc` (gc/compile.go) treats as a bodyless
declaration (ABI wrappers only, not compiled). The fix appended an empty
BlockStmt in `genericSubst`.

go1.27.3 has no stenciling (`genericSubst` is gone); unified IR builds all
bodies, including shaped instantiations, in `reader.funcBody`
(src/cmd/compile/internal/noder/reader.go). It carries the equivalent guard:
`if body == nil { body = []ir.Node{ NewBlockStmt } }`.

Change: removed that guard, so `fn.Body = r.stmts()` and an empty body is nil again.
This reverses the single fix hunk.

Result: `./check.sh` fails the oracle (Test/typeparam/issue49524.go and
TestShouldTest). Empty-bodied functions are now treated as bodyless, so they
are not compiled. The toolchain build fails in runtime ("write barrier
prohibited", "escapes to heap"), and the empty generic `a.F[int]` has no body
either. The failure is broader than the original because unified IR
shares this path for non-generic functions too.

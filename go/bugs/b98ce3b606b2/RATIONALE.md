# Rationale

Fix hunk: iimport.go `importReader.node` (OCLOSURE) — when an imported closure body was empty, substitute a single empty BlockStmt so the closure is not dropped.

go1.27.3 has no iimport closure path (unified IR only). The equivalent is `reader.funcBody` in src/cmd/compile/internal/noder/reader.go, which had the same guard: `if body == nil { body = []ir.Node{typecheck.Stmt(ir.NewBlockStmt(src.NoXPos, nil))} }`. I removed that guard, so `fn.Body = r.stmts()` can be nil for an empty function/closure body read from export data, and the function is treated as having no body (dropped).

Oracle: test/fixedbugs/issue44330.go (both cases) fail. The build breaks while compiling the runtime/std with the modified compiler (errors in runtime such as bogus escape/write-barrier diagnostics), so testdir never runs: a crash-type failure rather than the narrow issue44330 symptom.

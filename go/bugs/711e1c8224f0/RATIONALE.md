# Rationale

Fix 711e1c8 (issue 48097) made the compiler report two errors for invalid function declarations:
"can only use //go:noescape with external func implementations" (funcDecl hunk) and
"missing function body" under -complete (irgen.go hunk). In go1.27.3 the unified IR writer holds both
checks in `writer.funcExt` (src/cmd/compile/internal/noder/writer.go), so I removed them there:

- Dropped the `pragma&ir.Noescape != 0` error in the `decl.Body != nil` branch (reverses the decl.go hunk).
- Dropped the `else` branch that reports "missing function body" for bodyless, non-linknamed functions
  when `base.Flag.Complete` is set (reverses the irgen.go hunk). The wasmimport/init handling is
  part of that branch and went with it.

Failing oracle case: `Test/fixedbugs/issue48097.go` (errorcheck -complete). Both expected errors are
no longer emitted. The types2 cases pass, since the types2 package is unchanged.

# Rationale

Hunk changed: `src/cmd/compile/internal/bloop/bloop.go`, `keepAliveAt`.

It reverses the fix hunk that replaced the interface conversion with an unsafe.Pointer of the node's address. The
pre-fix code again converts `n` itself to `interface{}` (`OCONV` to `TINTER`), setting `TypeWord`/`SrcRType` for
non-interface types. It also restores the `reflectdata` import. This is the old computation, so each keep-alive
call introduces an interface conversion, which is unnecessary and shows up in escape analysis output.

Oracle failures: `Test/bloop.go` and `Test/escape_bloop.go` fail. The updated expectations no longer have
`.* does not escape` on the keep-alive lines, and the extra `(interface {})(.autotmp_1) does not escape`
diagnostics now appear as unmatched errors, which is the failure the fix's test guards against.

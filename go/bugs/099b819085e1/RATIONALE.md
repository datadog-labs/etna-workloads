# Rationale

Fix 099b819 made CheckSize() run at *every* level when types are built (noder `typ1`
and `Tsubster.typ1`), because CalcSize never descends past a pointer (pointer
width/align are preset). go1.27.3 has no Tsubster or types2 `irgen`; types are built by
the unified IR reader.

Changes:
1. `noder/reader.go` `pkgReader.typIdx`: removed the `if !typ.IsUntyped() { types.CheckSize(typ) }`
   run for each type the reader constructs. This is the analogue of the per-level
   `CheckSize` the fix added to `irgen.typ1` / `Tsubster.typ1`; without it, types
   reached only through pointers/chans (e.g. `*ValidationError`, `Chan[T]` elem) never get sized.
2. `types/size.go` `CalcSize` TPTR: removed `CheckSize(t.Elem())`, the later second path
   covering the same case (pre-fix code did not descend past pointers). Alone this
   does not make the oracle fail, since the reader covered it.

Oracle: test/typeparam/issue47901.go and issue47929.go both fail under ./check.sh
(2 of 2 cases each), as unsized types reach the backend.

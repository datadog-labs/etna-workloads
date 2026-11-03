# Rationale

Fix hunk: in inl.go `inlsubst.node`, the label translation done for OFOR/ORANGE was extended to OSWITCH (`m.Label = translateLabel(m.Label)`).

In go1.27.3 inlining goes through the unified IR reader (noder/reader.go). `reader.label()` renames labels to `~name·N` when inlining, and `stmt1` passes the preceding LabelStmt's (renamed) label to forStmt/selectStmt/switchStmt. I changed `case stmtSwitch` to `r.switchStmt(nil)`, so an inlined switch no longer carries the translated label, while `break loop` inside it still targets the translated label. This is the pre-fix state: the switch's label is not translated to match the inlined label/branches.

Oracle: test/fixedbugs/issue49145.go (inlined `f` with `break loop` on a labeled switch) now makes the compiler crash in ssagen (panic in `state.stmt`), so the build/run fails.

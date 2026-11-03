# Rationale

Inlining is now done by the unified-IR reader (`noder/reader.go`), not `inline/inl.go`. The old
`inlsubst` label rewriting (OGOTO, OLABEL, and the fix's new OBREAK/OCONTINUE/OFOR/ORANGE cases)
became a single `reader.label()`, which appends `~name·inlgen` when `r.inlCall != nil`.

Change: `label()` and `optLabel()` take a `translate` flag. `stmtLabel` and `goto` still translate,
which is the pre-fix behaviour for OLABEL/OGOTO. `break`/`continue` (the `stmtBranch` case with
`op != OGOTO`) read their label untranslated.

This reverses the fix hunk `case ir.OGOTO` -> `case ir.OGOTO, ir.OBREAK, ir.OCONTINUE`.
The loop's own label (the fix's OFOR/ORANGE translation) still comes from the translated
`stmtLabel`, so I did not revert it separately.

Result: an inlined `continue loop` or `break loop` names the untranslated `loop`, while the inlined
loop is labelled `~loop·N`. The branch no longer matches its own loop and can match a same-named
outer label. This is the issue 49100 bug.

Oracle: test/fixedbugs/issue49100.go fails (2/2 cases). The compiler crashes in ssagen on the
mismatched branch target. The pre-fix symptom was wrong output.

# Rationale

Fix (CL 366494, #49171): in `inlsubst.closure`, restore the inline-adjusted position on the new OCLOSURE node (`newclo.SetPos(subst.updatedPos(n.Pos()))`), while the closure's function body keeps original positions.

go1.27.3 has no `inlsubst`; inlining goes through the unified-IR reader. `reader.funcLit`/`inlClosureFunc` (src/cmd/compile/internal/noder/reader.go) is the equivalent: the closure Func gets the original pos, and the OCLOSURE node gets `r.inlPos(origPos)`.

Change: in `inlClosureFunc`, after `ir.NewClosureFunc(origPos, r.inlPos(origPos), ...)`, call `fn.OClosure.SetPos(origPos)`, so the OCLOSURE node loses its inline-adjusted position, as before the fix. (The inlPos is still passed to NewClosureFunc for naming; changing that makes closure symbols collide and breaks the runtime build.)

Failing oracle: Test/inline.go. "func literal does not escape" is reported at inline.go:101 (the closure literal) rather than at the inlined call on line 103, which is the symptom the fix's test edits guard against. (closure3.go still passes here.)

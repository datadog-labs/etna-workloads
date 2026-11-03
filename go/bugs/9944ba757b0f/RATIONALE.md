# Rationale

Fix reversed: transitive inlining of generic functions (#56280), hunks in noder/unified.go `readBodies`.

In go1.27.3 the fix's `inlDecls` path lives in `readBodies` (src/cmd/compile/internal/noder/unified.go). When called during inlining, instantiations of imported generic functions are collected into `inlDecls` and passed to `inline.CanInlineFuncs`, so they get inline bodies. I changed the collection site so every instantiation is appended to `target.Funcs` (the pre-fix behaviour) and never goes to `inlDecls`. The later `len(inlDecls) != 0` block is therefore dead, so CanInline is never run on `G[T]` instantiated while inlining an imported `F`. The `duringInlining` parameter is now unused. The linkshared check from #58966 was dropped with the condition.

The inline.go hunks (InlineDecls refactor) were already replaced by `CanInlineFuncs`, and the caller hunks only pass the flag, so no change is needed there.

Oracle failure: test/fixedbugs/issue56280.go fails with `main.go:10: missing error "inlining call to a.g[go.shape.int]"`. `a.F` is inlined into main but the call to `g` inside it is not.

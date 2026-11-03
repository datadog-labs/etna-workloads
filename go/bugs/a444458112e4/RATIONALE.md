# Rationale

Fix hunk (gc/gsubr.go ggloblnod): after emitting a global, `if nam.Sym.Linkname != "" { s.Pkg = "_" }`
so an imported-and-linkname'd variable is resolved by name, not by package index.

In go1.27.3 the equivalent block lives in `ggloblnod` in src/cmd/compile/internal/gc/obj.go. It was removed.

On its own that is not enough: the unified-IR reader (noder/reader.go `linkname`) calls
`sym.Linksym().Set(AttrLinkname...)` for local linkname'd symbols, which creates the LSym
early via `base.Linkname` (Pkg "_") before the imported `a.s` LSym (Pkg "a") can be created,
so the second path covers the case. That is the same defect (the LSym's Pkg being fixed by who
creates it first), so I restricted that early marking to non-variables (`name.Class != ir.PEXTERN`)
and mark variables at emission in ggloblnod (`s.Set(obj.AttrLinkname, true)`) — after all LSyms exist.
Caveat: the "std" flavour (AttrLinknameStd) for variables is no longer set.

Oracle: test/fixedbugs/issue42401.go fails: a.Get() after `s = "b"` returns "a" (panic FAIL, b.go:18),
because b's `s` and a's `s` are separate symbols.

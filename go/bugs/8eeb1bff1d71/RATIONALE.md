# Rationale

go1.27.3 has no stencil.go or reflect.go getDictionary; the unified IR reader
creates global dictionaries in `pkgReader.dictNameOf` (noder/reader.go).

## Changed hunk
`dictNameOf` no longer reuses an existing `sym.Def` for the global dictionary
symbol (`if sym.Def != nil { return sym.Def.(*ir.Name) }` removed). It always
creates a fresh `*ir.Name` and overwrites `sym.Def`.
This reverses both fix hunks (stencil.go getDictionaryValue and reflect.go
getDictionary): "make or reuse the name node for the dictionary sym" goes back
to "always make a new node and set sym.Def", so `sym.Def` can point to a
different node than one already handed out (the broken `Def == n` invariant).

## Oracle result
test/typeparam/issue47896.go fails (both cases): the build fails with
`symbol ...dict.X[T] redeclared`, because the dictionary is emitted twice.
Unlike 2021, this hits every package that instantiates generics (including
std packages), so the whole build fails, not just the one test.
Subdictionary cycles are not guarded anymore, either.

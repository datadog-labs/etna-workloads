# Rationale

Changed: `src/cmd/compile/internal/noder/reader.go`, `ObjAlias` case of `objIdxMayFail`.

Reverses the reader.go hunk of the fix (the "clumsy dance" that temporarily clears
`sym.Def` while `r.typ()` runs, so a recursive lookup of the alias being read does
not find it before its type is set, #66873). That block is removed and the old
`typ := r.typ(); setType(name, typ)` is restored. The other hunks cannot be reverted
meaningfully: `EnableAlias` is no longer set in irgen.go (aliases are on by default),
and the writer.go non-global alias stripping is a separate concern.
The `typeParamNames` call added since then is kept.

Oracle failures: test/fixedbugs/issue66873.go (`func f(A)`, `type A = T`, `func (A) m()`)
and test/alias2.go both fail, because the alias is found by the recursive read
before its type is set, giving the initialization loop / bad alias type.

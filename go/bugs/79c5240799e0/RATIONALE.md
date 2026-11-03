# Rationale

Fix (#49241): type descriptors must always be DUPOK so that a type has only one descriptor.
The pre-fix code set DUPOK only for unnamed or shape types, and its TODO said instantiated types probably needed it too.

Change: `src/cmd/compile/internal/reflectdata/reflect.go`, in `writeType`.
The DUPOK condition `tbase.Sym() == nil || tbase.IsFullyInstantiated() || tbase.HasShape()` is now `tbase.Sym() == nil || tbase.HasShape()`.
This reverses the fix hunk that made `objw.Global` always use `obj.DUPOK`.
Go 1.27.3 has since narrowed the always-DUPOK rule to a condition that includes `IsFullyInstantiated()`.
Dropping that term restores the pre-fix behaviour: descriptors for fully instantiated named types (such as `a.T[int]`) are not DUPOK.

Oracle: `Test/typeparam/issue49241.go` fails.
`b.F() != c.F()`, because two descriptors for `a.T[int]` are emitted, one in each of packages b and c. The test prints both pointers and panics with "bad".

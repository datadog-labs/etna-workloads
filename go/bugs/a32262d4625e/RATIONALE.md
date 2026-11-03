# Rationale

Fix (issue #38515): `usemethod` in walk.go only recognised `reflect.Method` when
`s.Pkg.Path == "reflect"`; it had to also accept `s.Pkg == localpkg && myimportpath == "reflect"`
so that the method wrapper `reflect.Type.Method` inside package reflect is marked REFLECTMETHOD.

In go1.27.3 the check is `types.ReflectSymName(s) == "Method"/"Value"` in
`src/cmd/compile/internal/walk/expr.go` (`usemethod`). `LocalPkg.Path` is now the real
package path, so the local-package case is covered automatically. I restored the old
defect by making that check not recognise symbols from the package being compiled
(`s.Pkg != types.LocalPkg`), so while compiling reflect itself the result type
`reflect.Method` is not recognised and the wrapper is not marked REFLECTMETHOD.
Other packages still work (their `s.Pkg` is the imported reflect package).

Oracle: test/reflectmethod5.go and reflectmethod6.go fail (the linker deadcodes the
exported method `foo.X`, so the program crashes/panics).

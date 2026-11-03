# Rationale

Fix (#48094): export/import of builtins now distinguishes `unsafe` builtins
(`unsafe.Sizeof` etc.) from universe builtins. Before, `unsafe` builtins were
exported as members of the builtin package, so the importer looked them up in
`types.BuiltinPkg` and failed.

go1.27.3 has no iexport/iimport for this (unified IR). The equivalent is
`pkgWriter.pkgIdx` in `src/cmd/compile/internal/noder/writer.go`, which now
serializes the universe as "builtin" and package unsafe as "unsafe" (reader:
`doPkg` maps these to `BuiltinPkg`/`UnsafePkg`).

Change: `case nil, types2.Unsafe:` writes "builtin" for both, removing the
separate "unsafe" case. This reverses the fix's `w.bool(pkg == UnsafePkg)` /
`pkg = UnsafePkg` hunks: unsafe builtins are again written as universe builtins,
so the reader looks them up in `BuiltinPkg`, finds `Def == nil` and panics
(`interface is nil, not ir.Node`).

Oracle: test/typeparam/issue48094.go (both cases) fails; the build of std
(e.g. internal/abi, which uses unsafe.Sizeof) crashes with that ICE.

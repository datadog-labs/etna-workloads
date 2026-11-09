Ambient `declare namespace NS` (type-only) is exported with `export = NS` in a .d.ts, under verbatimModuleSyntax.
Clean: no diagnostics, exit=0. Injected: reports an `export =` error (TS1286-style) in the ambient declaration file, exit=2.

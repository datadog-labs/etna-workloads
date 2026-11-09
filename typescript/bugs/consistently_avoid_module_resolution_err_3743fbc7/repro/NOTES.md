input.ts imports "./data.json", which resolves to data.d.json.ts without --allowArbitraryExtensions (error TS6263). It is compiled with `--incremental`, so the `.tsbuildinfo` records the file dependencies.
Clean: the import still resolves to a module symbol, so `referencedMap` has an entry linking input.ts to data.d.json.ts.
Injected: the import resolves to no symbol because of the resolution diagnostic, so `referencedMap` is missing.

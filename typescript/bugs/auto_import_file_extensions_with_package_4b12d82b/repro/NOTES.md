Language-service "add missing import" code fixes for `add` (src/add.ts) with allowImportingTsExtensions and a package.json `imports` wildcard (`#*` -> `./src/*`); also `external` from a package with an `exports` wildcard.
Clean suggests `Add import from "#add.ts"`; injected suggests `"#add.js"` (the .ts extension is lost). The `pkg/external.js` fix is the same in both.

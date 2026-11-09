b.ts has `export import a = require("./a")` where a.ts uses `export =`, with allowSyntheticDefaultImports.
run.js prints the language service suggestion diagnostics for b.ts.
Clean: no "Import may be converted to a default import" suggestion (80003) for the exported import-equals.
Injected: that suggestion is wrongly reported.

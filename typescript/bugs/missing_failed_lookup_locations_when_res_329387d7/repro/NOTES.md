Resolves `#utils` (package.json `"imports"` -> bare specifier `lodash`) with `ts.resolveModuleName` under NodeNext, using an in-memory host.
The package resolves to /a/b/node_modules/lodash/index.d.ts and the script prints `failedLookupLocations`.
Clean: the list includes the failed node_modules lookups from the nested bare-specifier resolution (e.g. /a/b/c/d/e/node_modules/...).
Injected: those entries are missing, because the nested result's failed lookup locations are not propagated.

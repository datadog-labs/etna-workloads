Project depends on `pkg`, whose package.json has wildcard exports `./core/*` with `types: ./lib/core/*.d.ts`.
A ProjectService (AutoImportProvider) asks for auto-import completions at the empty main.ts and prints the `test` entry.
Clean: `test` from `pkg/core/test` is offered (hasAction true). Injected: entry missing (`[]`), since the export-map
wildcard target `.d.ts` extension is mangled when finding entrypoints.

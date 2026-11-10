Input imports "pkg/sub", where node_modules/pkg/package.json has `"types": "main.d.ts"` and only the subdirectory pkg/sub contains a main.d.ts (no index.d.ts, no package.json there).
Clean: the package's `types` field is applied only at the package root, so pkg/sub fails to resolve (TS2307, exit 2).
Injected: the root package.json `types` is wrongly applied to the subdirectory, so pkg/sub/main.d.ts is found and the compile succeeds (exit 0).

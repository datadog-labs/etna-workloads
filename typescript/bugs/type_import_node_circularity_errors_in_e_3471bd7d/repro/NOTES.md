Input: `index.ts` uses a deprecated type via `import('./types').SelectorMap<F>` in a type-parameter constraint.
The script prints language-service suggestion diagnostics for index.ts.
Clean: reports the 6385 "'SelectorMap' is deprecated" suggestion for the import type.
Injected: the import type node skips the deprecation check, so that suggestion is missing.

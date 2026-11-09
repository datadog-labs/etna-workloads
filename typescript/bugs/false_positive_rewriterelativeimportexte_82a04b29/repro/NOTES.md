index.mts imports "./example.json" and "./styles.css" (resolving to styles.d.css.ts) with rewriteRelativeImportExtensions on, module nodenext.
Clean: no errors (non-TS extensions are not rewritten). Injected: TS2876 "relative import path is unsafe to rewrite" on both imports, exit 2.

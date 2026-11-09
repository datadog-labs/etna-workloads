Input: a JS file exports a const whose inferred type (from a .d.ts) contains `globalThis.ERef<import("./types.js").ParamStateRecord>`, where ERef is a global alias re-exported via `declare global { export {...} }`; emits declarations only.
Clean: declaration emit succeeds and prints index.d.ts.
Injected: the module-symbol check is loosened (flags & Module instead of isExternalModuleSymbol), so declaration emit differs/crashes (exit status and output differ).

Project with bundler resolution; package `pkg` has exports with `import` -> index.js and `require` -> index.cjs (index.d.cts is empty).
index.ts's declaration emit must reference class `C` via `import("pkg").C`.
Clean: emits `export declare const c: import("pkg").C;` and exits 0.
Injected: module specifier generation uses the CommonJS "require" condition, so it fails to name `pkg` (declaration emit error / different output).

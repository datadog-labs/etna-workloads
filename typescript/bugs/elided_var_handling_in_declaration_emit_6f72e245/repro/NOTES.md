Input: `var a` inside a bare block, then `export let b: typeof a;`, compiled with `--declaration --emitDeclarationOnly`.
Clean: reports error TS4025 (private name 'a'), exits 1 and writes no .d.ts.
Injected: no error, exits 0, and emits `export declare let b: typeof a;` (dangling reference).

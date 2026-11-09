Compiles a trivial file with `--target es2024 --noEmit --listFiles` and prints the default lib file loaded (paths stripped to `lib.*`).
Clean: loads `lib.es2024.full.d.ts`. Injected: ES2024 is missing from targetToLibMap/getDefaultLibFileName, so it falls back to the default `lib.d.ts`.

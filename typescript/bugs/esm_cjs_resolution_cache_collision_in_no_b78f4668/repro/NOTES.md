Bundler resolution with `pkg` having conditional exports (import -> index.d.mts "esm", require -> index.d.ts "cjs").
index.ts imports the same specifier twice with `resolution-mode` "require" and "import", then assigns literals to `typeof` each.
Clean: each import resolves to its own file, so no errors. Injected: the resolution cache collides (mode keyed only on EsmMode),
so the "import" one resolves to the cjs types and tsc reports a type error.

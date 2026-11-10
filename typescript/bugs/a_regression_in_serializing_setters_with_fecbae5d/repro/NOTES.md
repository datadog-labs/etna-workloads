Input: a JS file (allowJs + declaration) with `Object.defineProperty(I.prototype, "x", { set: (v) => {} })` and `{ set: 42 }`, i.e. setters that are not plain function-likes/methods.
Clean build: emits the .d.ts normally and exits 0.
Injected build: the setter serialization asserts that the setter is function-like, so tsc crashes (Debug failure) and the exit status/output differs.

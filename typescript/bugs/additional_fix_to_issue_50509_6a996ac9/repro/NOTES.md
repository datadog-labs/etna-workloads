Input: a.js (allowJs, noImplicitThis) passes a nested object literal `{ m: { initData() { this.x = 1; this.x; } } }` to a function whose parameter is `{ m: Record<string, Function> } & ThisType<{ x: number }>`; the script runs findReferences on `this.x`.
Clean: `this.x = 1` is treated as a reference to the ThisType's `x` (a.js offset 88, a write access is listed).
Injected: the nested literal's ThisType is not found when classifying the `this.x = 1` assignment, so that reference is missing.

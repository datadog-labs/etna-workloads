Input: `return <const T extends/>` in a .tsx file (JSX with intrinsic tag `const`, attributes `T` and `extends`).
Clean: parsed as JSX, emits `React.createElement("const", { T: true, extends: true })`.
Injected: `<const T extends/` is mis-parsed as a generic arrow function start, emitting `() => ;` (plus errors).

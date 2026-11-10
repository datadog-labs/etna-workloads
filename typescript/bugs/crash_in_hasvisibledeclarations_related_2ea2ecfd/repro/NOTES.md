Input declares a class property arrow function whose body destructures `for (const [key, value] of ...)` and uses a computed property `[key]: value`. It is compiled with `--declaration --emitDeclarationOnly`.
Clean: emits the .d.ts and exits 0.
Injected: `hasVisibleDeclarations` crashes with `TypeError: Cannot read properties of undefined (reading 'kind')`, exit 1, no .d.ts.

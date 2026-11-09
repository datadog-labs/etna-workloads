Three JS files (index.js, Test.js, test/Test.js) each define a `Test` class; index.js imports one and its JSDoc typedef references `import("./Test.js").default`.
repro.sh compiles with `--allowJs --declaration --emitDeclarationOnly` and prints the emitted index.d.ts.
Clean: the trailing import is `import Test from './test/Test.js';`.
Injected: a private symbol from another file is tracked, so it is emitted as `import Test_1 from ...`, while `extends Test` stays unrenamed and is unresolved.

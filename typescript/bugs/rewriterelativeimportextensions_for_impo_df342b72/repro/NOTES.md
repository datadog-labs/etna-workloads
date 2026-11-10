Input is an ES module with `foo(import("./a.ts"))`, compiled with `--rewriteRelativeImportExtensions --module esnext`.
The `import()` is nested as an argument inside another call expression.
Clean emits `foo(import("./a.js"))`. Injected leaves `foo(import("./a.ts"))`, because the visitor no longer descends into the outer CallExpression.

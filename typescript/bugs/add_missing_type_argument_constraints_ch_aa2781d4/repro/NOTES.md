file2.ts uses the import type `import('./file1').Foo<T>` where `Foo<T extends string>` and `T` is unconstrained.
Clean tsc reports error TS2344 (Type 'T' does not satisfy the constraint 'string'); the injected build skips the type-argument constraint check on import types and reports nothing.
Run with `tsc -p tsconfig.json` (noEmit); the output and exit code differ.

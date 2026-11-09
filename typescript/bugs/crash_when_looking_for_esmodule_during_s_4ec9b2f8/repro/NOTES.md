Input: bar.d.ts does `import * as foo from './foo'; export as namespace foo; export = foo;` plus `declare global { const foo: typeof foo }`; foo.d.ts is `export = root` where root's interface has a `default` property; compiled with --esModuleInterop.
Clean: reports TS2451/TS2502 diagnostics (exit 2).
Injected: tsc crashes with TypeError "Cannot read properties of undefined (reading 'flags')" in resolveExportByName (exit 1).

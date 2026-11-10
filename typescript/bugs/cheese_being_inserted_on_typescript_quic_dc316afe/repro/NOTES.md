Input: /b.ts declares `f(a: any)`, /c.ts imports class A from /a.ts and calls `f({}, new A())`; repro.mjs asks the language service for the "Add missing parameter" code fix (TS2554).
Clean: the fix adds `p0: A` to f in b.ts and also inserts `import { A } from "./a";`.
Injected: the parameter type is added but the import is missing (the type A is unresolved in b.ts).

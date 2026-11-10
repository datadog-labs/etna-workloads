Input: a.ts exports a unique-symbol const `a`; b.ts imports it and uses it as a computed key in a destructured parameter: `fn({ [a]: value }: any)`.
Runs tsc with --declaration --emitDeclarationOnly and prints out/b.d.ts.
Clean: b.d.ts keeps `import { a } from "./a";` before the declaration.
Injected: the import is dropped (computed key's visibility is no longer checked), so the .d.ts references an undeclared `a`.

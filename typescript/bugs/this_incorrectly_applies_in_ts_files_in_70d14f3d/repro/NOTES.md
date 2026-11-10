input.ts is a TypeScript file (not JS) with a function carrying a JSDoc `@this {string}` tag.
main.mjs asks the language service for quick info and the checker for typeToString of the function.
Clean: `function f(x: number): void` / `(x: number) => void` (the @this tag is ignored in TS files).
Injected: a `this: string` parameter wrongly appears in the printed signature.

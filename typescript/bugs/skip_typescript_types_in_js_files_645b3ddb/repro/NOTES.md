Input a.js (checkJs) declares `@type {{ f: (x: string) => number }}` on `export const foo = {}`, and run.js asks the language service for the "Add missing properties" code fix.
Clean: the generated method stub is JS-style, `f: function(x) {...}`, with no TS types.
Injected: the stub keeps TypeScript types (parameter type / return type) in the .js file.

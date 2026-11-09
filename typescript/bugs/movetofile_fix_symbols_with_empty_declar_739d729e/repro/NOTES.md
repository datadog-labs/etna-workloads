Input: `/orig.ts` with `export const variable = undefined;`, moved to a new file via the language service "Move to file" refactor.
Clean: new file contains only `export const variable=undefined;`.
Injected: the `undefined` symbol (empty `declarations`) is treated as importable, so the new file gets a bogus `import { undefined } from "./orig";`.

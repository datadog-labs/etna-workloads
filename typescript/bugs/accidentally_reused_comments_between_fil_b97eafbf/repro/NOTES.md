a.ts re-exports a value whose type (from obj.d.ts) contains `import("./id")` types, and a.ts ends with a leading-comment-like JSDoc block.
Declaration emit of a.d.ts: clean emits `foo: import("./id").Id<{}>;`.
Injected copies the JSDoc comment from a.ts into the import type (around "./id"), producing a mangled `import(/** huh */ "./id" /** huh */)`.

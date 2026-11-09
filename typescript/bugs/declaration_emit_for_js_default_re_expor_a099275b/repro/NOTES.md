Input: `index.mjs` does `export {default as mod} from 'a'`, where `a` is a node_modules package with only `index.d.ts` (no default export); compiled with node16, declaration, emitDeclarationOnly, checkJs.
Clean: emitted `index.d.mts` keeps `export { default as mod } from "a"`.
Injected: the declaration is rewritten to `export { "<path>/node_modules/a/index" as mod } from "a"`, which is invalid (the script prints BUG/OK instead of the path).

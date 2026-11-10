Input exports a function declaration and re-exports it under another name (`export { f as fV2 }`), compiled to CommonJS.
Clean emits `exports.f = f; exports.fV2 = f;` once each.
Injected emits those two assignments twice (duplicate `exports.* = f`), because the exported function is no longer looked up via its original node.

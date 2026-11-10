Input declares a function and re-exports it via `export { foo }; export { foo as bar };`, compiled to CommonJS.
Clean: hoisted `exports.foo = foo; exports.bar = foo;` before the function.
Injected: emits `exports.bar = exports.foo = void 0;` and never assigns the function, so exports are undefined.

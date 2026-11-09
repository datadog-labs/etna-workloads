input.ts declares `type Foo`, `export const Foo = 1;` and `export default Foo;` (the default export refers to both a type and a value).
Compiled with `tsc --target esnext`, the clean build emits `export default Foo;` in the JS.
The injected build drops that line, so only `export const Foo = 1;` is emitted.

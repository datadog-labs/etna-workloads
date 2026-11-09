b.js has a multi-line JSDoc `@import { Foo } from "./a"` (each line starting with ` *`), plus a function using `@param {Foo}`.
tsc emits declarations (b.d.ts) for it.
Clean: `export function foo(a: Foo): void;`. Injected: the leading-asterisk handling is wrong, so it emits `foo(a: *    Foo): void;`.
The injected build also reports TS1005/TS7006 errors in the generated d.ts.

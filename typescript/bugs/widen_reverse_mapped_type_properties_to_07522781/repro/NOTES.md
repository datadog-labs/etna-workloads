input.ts calls a generic function `fn3<Options extends Flags>(options: Readonly<Options>): Options` with an object literal, which makes the compiler infer `Options` through a reverse mapped type, then passes one property of the result to `takeType(arg: { type: unknown })`.
Clean build: no diagnostics, exit 0.
Injected build: reports TS2353 "Object literal may only specify known properties, and 'default' does not exist in type '{ type: unknown; }'", exit 2. Without widening, the reverse-mapped property types are treated as fresh object literals and so get excess-property checks.

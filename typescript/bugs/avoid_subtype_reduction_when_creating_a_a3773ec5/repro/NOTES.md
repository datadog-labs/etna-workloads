Input calls a generic `parse` whose parameter is a recursive conditional/mapped type `narrow<def>`, with argument `[{ a: "foo" }]`.
The emitted .d.ts shows the inferred type of `result`.
Clean: `[{ a: "foo"; }]`. Injected: `[{ a: string; }]` (the discriminated union is subtype-reduced, so the literal is widened).

Input: a JS file (checkJs) where an exported class extends a base with a static property and then assigns `Foo.foo = "foo"` (expando).
tsc emits declarations only; the synthesized `namespace Foo` contains the property.
Clean emits `let foo: string;` inside the namespace; injected emits `const foo: string;`.

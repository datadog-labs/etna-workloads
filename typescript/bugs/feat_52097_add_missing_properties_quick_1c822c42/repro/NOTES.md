Input: a mapped type `A` whose properties are `{ name: K, value: \`Foo ${Uppercase<K>}\` }`, and `const a: A = {};`.
The repro.mjs script asks the language service for the "Add missing properties" code fix on that line and prints the inserted text.
Clean: properties are filled with `name: "a", value: "Foo A"` (and "b"/"Foo B").
Injected: it uses the declaration's type instead of the property's instantiated type, so the filled-in values differ.

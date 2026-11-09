Input: arrow function with a type parameter `E` shadowing an imported namespace `E`, using `E.Whatever<E>` in annotations; compiled with --declaration.
Clean: the .d.ts keeps `import * as E from 'whatever';` (namespace meaning looked up for the qualified name).
Injected: the import is dropped from the .d.ts (lookup finds type parameter E), producing a .d.ts that references `E` wrongly.

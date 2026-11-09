Input: an exported object literal with divergent accessors (`get x(): string`, `set x(v: number)`), compiled with `--declaration --emitDeclarationOnly`.
Clean: the .d.ts keeps the divergent accessors (`get x(): string; set x(v: number);`).
Injected: the property is emitted as a single type, with the write type lost.

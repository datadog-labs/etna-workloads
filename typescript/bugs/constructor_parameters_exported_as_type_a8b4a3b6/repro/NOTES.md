a.ts declares class Foo and re-exports it with `export type { Foo }`; b.ts imports Foo and uses it as a decorated class's constructor parameter type, with emitDecoratorMetadata.
Clean emits `__metadata("design:paramtypes", [Function])`; injected emits `[Foo]` (referencing a type-only export as a value).

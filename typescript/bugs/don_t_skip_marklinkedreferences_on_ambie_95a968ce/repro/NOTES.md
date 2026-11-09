Input: a class with a decorated `declare prop: Observable<string>` property, where Observable is imported from a .d.ts, compiled with emitDecoratorMetadata + experimentalDecorators.
Clean: the import is retained in emitted JS (`require("./observable")`) since the metadata references it.
Injected: markLinkedReferences skips ambient properties, so the import is elided and the metadata output differs.

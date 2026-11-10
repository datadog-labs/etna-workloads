Input is a JS class method whose JSDoc uses `@param {Object} [bar]` with nested `bar.a`, `bar.b`, `bar.c` tags.
repro.sh asks the language service for the "Annotate with type from JSDoc" code fix (diagnostic 80004) on that method.
Clean: the fix text includes the object literal type `{ a: string; b?: number; c: any; }`.
Injected: the JSDoc type literal isn't transformed, so the annotation differs (the nested property type is wrong or missing).

Input: an object literal with a getter whose return statement has an error (`_this.collection` on `this`), compiled with --strict --declaration.
Clean: the .d.ts emits `readonly primaryPath: any;` (error types skip the accessor path).
Injected: emits `get primaryPath(): any;` because the error-type check was removed.

Input: a JS class with a setter `set bar(baz)` whose param is typed via JSDoc; compiled with allowJs + emitDeclarationOnly.
Clean emits `set bar(baz: string);` in foo.d.ts; injected emits `set bar(arg: string);` (param name replaced by "arg").

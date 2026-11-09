Input: a generic arrow function whose inferred return type is a template literal type containing literal newlines; compiled with `tsc --declaration --emitDeclarationOnly`.
Clean: the emitted .d.ts keeps real line feeds inside the template literal type.
Injected: the line feeds are escaped as `\n` (the backtick escape regex now covers U+000A).

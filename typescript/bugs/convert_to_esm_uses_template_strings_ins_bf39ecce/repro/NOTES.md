Input: `const foo = require(`foo`);` in a .ts file (template-literal specifier); asks the language service for the "Convert require to import" code fix.
Clean: the fix emits `import foo = require("foo");` (string literal).
Injected: the template literal is reused, giving ``import foo = require(`foo`);``.

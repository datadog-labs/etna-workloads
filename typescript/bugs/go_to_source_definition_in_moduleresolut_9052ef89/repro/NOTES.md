b.js (checkJs, moduleResolution bundler) does `const m = require("./a")` of a.ts and assigns the number export m.x to a string-typed var.
Clean: require is resolved as a module import, so a.ts is in the program and a type error is reported.
Injected: require is ignored under bundler, so a.ts is not listed and no error is reported.

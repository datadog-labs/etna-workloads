Input a.js (allowJs, noImplicitThis) calls a JSDoc-typed `infer` whose parameter is `{m(): void} & ThisType<{x: number}>`, with an object literal whose method does `this.x = 2; this.x;`.
The script runs the language service's findReferences on the `this.x` read.
Clean: the `this.x = 2` assignment is listed as a write reference. Injected: it is missed (treated as a JS special property assignment), so only the read is listed.

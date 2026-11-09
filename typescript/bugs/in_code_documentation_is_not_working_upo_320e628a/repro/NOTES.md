Input: a.d.ts declares `export declare const A: T` (T a function type alias) with a JSDoc comment; b.ts imports A and calls it.
The script requests language-service quick info on the imported `A`.
Clean: documentation includes "docs - const A: T". Injected: documentation is empty.

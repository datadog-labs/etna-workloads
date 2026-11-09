Input: an exported class whose constructor has a parameter property with an initializer followed by a required parameter (`public a: number[] = [], b: number`), compiled with --strict --declaration.
Clean emits `constructor(a: number[] | undefined, b: number);` in the .d.ts; injected emits `constructor(a: number[], b: number);` (missing `| undefined`).

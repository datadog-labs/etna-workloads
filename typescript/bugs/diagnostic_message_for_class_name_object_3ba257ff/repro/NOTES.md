Input declares `export class Object {}` and is compiled with `--module commonjs --target es2015`, which triggers error TS2725.
Clean prints "Class name cannot be 'Object' when targeting ES5 and above with module CommonJS."
Injected prints the older wording "...when targeting ES5 with module CommonJS."

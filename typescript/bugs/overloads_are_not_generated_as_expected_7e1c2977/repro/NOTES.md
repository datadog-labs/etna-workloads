a.js assigns a function to `Foo.prototype.bar` with two standalone `/** @overload */` JSDoc comments before it, and declaration emit is run on it.
Clean: the .d.ts has two overload signatures `bar(a: string): void;` and `bar(a: number, b: string): void;`.
Injected: the overload comments are dropped, leaving only the implementation signature `bar(a: string | number, b?: string): void;`.

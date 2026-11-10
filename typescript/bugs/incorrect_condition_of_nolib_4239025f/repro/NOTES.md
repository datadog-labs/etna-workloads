Creates a program for a trivial input.ts without `noLib` and asks `program.isSourceFileDefaultLibrary` about lib.es5.d.ts and input.ts.
Clean: lib.es5.d.ts -> true, input.ts -> false.
Injected: lib.es5.d.ts -> false, because the function returns false whenever `noLib` is not set.

Creates a program for input.ts (default options, noLib off) and prints isSourceFileDefaultLibrary for each source file.
Clean: lib.*.d.ts files report true. Injected: they report false (the check returns false whenever noLib is unset).

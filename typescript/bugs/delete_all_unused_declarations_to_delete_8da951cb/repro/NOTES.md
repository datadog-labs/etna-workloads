input.ts has a self-recursive unused function `fibonacci` and an unused `other`; run.mjs applies the language service "Delete all unused declarations" fix-all (unusedIdentifier_delete) and prints the result.
Clean: both functions are deleted (output is just `export {};`).
Injected: the self-referential function is not deleted (it remains in the output).

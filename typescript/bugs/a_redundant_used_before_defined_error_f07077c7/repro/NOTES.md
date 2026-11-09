input.ts references a const inside its own initializer via `typeof qwe` in a type assertion (type context).
Clean: no errors, exit 0. Injected: spurious TS2448 "Block-scoped variable 'qwe' used before its declaration", exit 2.

input.ts declares an unannotated `using` with an object literal that has an extra property (`value`) beyond Symbol.dispose.
Clean: no errors (initializer type is widened before the Disposable check, so no excess property check).
Injected: reports TS2353 "'value' does not exist in type 'Disposable'" and exits with 2.

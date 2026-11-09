Input: class A has a method `foo` with JSDoc `@virtual`; B and C override it in a chain (grandparent inheritance).
The script asks the language service for quick info on `foo` in B and C and prints the JSDoc tags.
Clean: both show `[{"name":"virtual"}]`. Injected: the inherited tag is lost (tags empty/missing) for C.

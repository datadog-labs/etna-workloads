Input: a class with a parameter property `private x?: Array | undefined` (unresolved generic `Array`, an error type), compiled with `--strict --isolatedDeclarations --declaration --emitDeclarationOnly`.
Clean: only TS2314 (Array requires a type argument).
Injected: also a spurious TS9025 ("requires implicitly adding undefined") because the error type is no longer treated as containing undefined.

A generic function returns a local typed as a homomorphic mapped type over `keyof PartialProperties<T, "prop">`, compiled with `--declaration --emitDeclarationOnly --keyofStringsOnly`.
Clean build emits the inline mapped type in the .d.ts return type as written.
Injected build wrongly treats it as a homomorphic mapped type with a non-homomorphic instantiation, so the declaration output or exit status differs (a different return type is printed).

Input: the compiler test reverseMappedUnionInference — `unionType([...])` infers `Result` through a reverse mapped type over a tuple of two `Extractor`s, then assigns the result to `number` to surface the type in the error.
Clean: myUnion is `AnyExtractor<{node: Identifier...} | {node: StringLiteral...}>`, and the error message shows that type.
Injected: inference falls back to `AnyExtractor<unknown>`, so the error message differs.

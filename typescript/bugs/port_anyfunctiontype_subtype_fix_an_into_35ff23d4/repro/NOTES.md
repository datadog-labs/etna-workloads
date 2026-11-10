Input is the compiler test subtypeReductionWithAnyFunctionType.ts: a context-sensitive lambda returned alongside `() => true` in a generic call, and an array literal mixing `Fooer` with `{foo: v => v}`.
Clean build: compiles with no errors.
Injected build: anyFunctionType is treated as a supertype too in signature relation, so subtype reduction picks the wrong type and tsc reports type errors.

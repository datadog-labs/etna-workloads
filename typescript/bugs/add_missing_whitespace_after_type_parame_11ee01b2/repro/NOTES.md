Input: a function expression with a `const T` type parameter, queried via language service provideInlayHints (interactive, return type hints).
Clean: the return-type hint display parts render `<const T>` with a single space after `const`.
Injected: a duplicate space is emitted (`const  T`).

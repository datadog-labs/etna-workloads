Input: a language-service "Extract to function in global scope" on the generic arrow `<T>(x: T) => x` inside `f`.
Clean: T is declared inside the extraction range, so the new function has no type parameter (`function newFunction() { return <T>(x: T) => x; }`).
Injected: the declaration-before-position check is missing, so T is wrongly captured as a type parameter of the extracted function (or the refactor errors).

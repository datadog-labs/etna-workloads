Input: a class whose constructor calls an undeclared private method `this.#foo()`.
A language-service code-fix request at `#foo` (error codes 2339/18013) is printed.
Clean: offers "Declare method '#foo'" with a `#foo() { throw ... }` text change.
Injected: returns no fixes (0), because private identifiers are skipped.

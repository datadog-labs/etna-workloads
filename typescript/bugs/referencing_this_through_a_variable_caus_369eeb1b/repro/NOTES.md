Input: a.js where `var foo = this; foo.x = 1;` inside a function; ask the language service for rename locations at `foo` in `foo.x`.
Clean: returns both `foo` occurrences. Injected: the use resolves to the wrong symbol (property `x`), so the rename locations are wrong/missing.

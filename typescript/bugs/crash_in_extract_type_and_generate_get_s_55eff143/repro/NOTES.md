Input: `const foo = { async a: 1 }` (property assignment with a grammar-error modifier), run through the language service "Generate 'get' and 'set' accessors" refactor.
Clean: the `async` modifier is stripped and the edit is printed (`_a: 1, get a() {...}, set a(value) {...}`).
Injected: the grammar-error modifier is kept (or the refactor crashes), so the output/exit status differs.

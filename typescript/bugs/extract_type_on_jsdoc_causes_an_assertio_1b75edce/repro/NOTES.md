Input a.js has a JSDoc `@type {Foo}` comment with no enclosing statement; run.mjs asks the language service
for the "Extract type" -> "Extract to typedef" refactor on `Foo`.
Clean: returns edits that insert an `@typedef {Foo} NewType` comment and replace the type.
Injected: throws a debug assertion ("Should find a statement") instead.

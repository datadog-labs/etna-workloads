Input: a class with a private field #prop and a type annotation `Foo.#prop` (invalid private identifier in a type reference); the script asks the language service for quick info right after `#prop`.
Clean: returns undefined (no crash). Injected: throws "Debug Failure. Unknown entity name kind. SyntaxKind: PrivateIdentifier".

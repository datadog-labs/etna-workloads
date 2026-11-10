Input a.js (checkJs) has a JSDoc `{@link this.#c}` referring to a private method.
Clean build reports no errors (exit 0); the injected build parser reports
`error TS1003: Identifier expected` at the `#c` in the link (exit 2).

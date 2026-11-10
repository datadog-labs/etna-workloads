Input: a JS file where an expando class (`Core.Test = class {}`) is assigned to an object property, then used via `new Core.Test()`.
repro.sh asks the language service for go-to-definition on `Test` in the `new` expression.
Clean: returns a definition list (no crash). Injected: throws Debug.fail "Expected declaration to have at least one class-like declaration".

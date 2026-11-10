Arrow functions typed as interfaces with call signature plus a property keyed by a unique symbol or a const string (`[mySymbol]: true`, `test: true`) are then assigned via element access (`foo[mySymbol] = true`, `bar[t] = true`).
Clean: no errors. Injected: TS2322 reports the expando property as `boolean` instead of the declared `true`, so the arrow function isn't assignable to `Foo`/`Bar`.

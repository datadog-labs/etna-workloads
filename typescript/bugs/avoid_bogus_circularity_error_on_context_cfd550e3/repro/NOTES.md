Input assigns an IIFE returning an object to an expando property `app.foo.bar` on a declared namespace function, under noImplicitAny, then uses `app.foo.bar.someFun(1)`.
Clean: no diagnostics (exit 0).
Injected: bogus circularity errors TS7022 on `bar` and TS7024 on the IIFE (exit 2).

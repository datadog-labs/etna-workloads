a.js has a JSDoc `@import { Foo }` used only inside a `@type` annotation within a function; checked with checkJs + noUnusedLocals.
Clean: no diagnostics.
Injected: reports TS6133 "'Foo' is declared but its value is never read." on the @import.

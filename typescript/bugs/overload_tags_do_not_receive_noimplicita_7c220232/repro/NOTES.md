a.js (checkJs, noImplicitAny) has a function with two JSDoc `@overload` tags that lack `@returns`.
Clean tsc reports implicit-any return type errors (TS7010-style) on the overload tags.
The injected build omits those errors, so its output differs.

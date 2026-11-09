Input: `const a1: '"' = '"'; function fn(a = a1) {}` with interactive parameter-type inlay hints via the language service (repro.mjs).
The hint for `a` shows the string literal type `'"'`.
Clean: the literal text is escaped properly (`"\"" `). Injected: the quote is emitted unescaped (`"""`), because the injected build wraps the raw text in quotes.

Input: `const x = 1; const y = x.toString();` in a language service; runs the "Inline variable" refactor on `x`.
Clean: replacement text is `(1)` (parenthesized, so `(1).toString()`).
Injected: the numeric literal is inlined without parentheses, giving `1.toString()` (invalid code).

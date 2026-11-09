Input: a language-service completion request inside `f("")` where the parameter type is a union of string literals containing `"`, a newline and `'`.
Clean: completion names are escaped (e.g. `a\"b`, `c\nd`).
Injected: names are the raw values (a literal `"` and a real newline), so they are not valid string-literal text.

Input: `const a = 1;;` followed by `const b = 2;` and `;[1, 2, 3]`, formatted via the language service
(`getFormattingEditsForDocument`) with `semicolons: Remove`.
Clean: the extraneous `;;` is removed (`const a = 1`). Injected: the extra semicolon is left in place.

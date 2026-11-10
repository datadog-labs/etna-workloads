Input: `const d = 1` / `d` / `const e = 1` (no semicolons), asking the language service for completions and entry details for `d` and `e` after the bare `d` and at end of file.
Clean: completion details show the variable's type (`const d: 1`).
Injected: the closest declaration is taken to be the enclosing variable declaration, so the details come out different (wrong or missing variable suggestion info).

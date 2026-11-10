Input: `globals.d.ts` declares ambient modules `"*.css"` (a wildcard pattern) and `"plain-mod"`; `a.ts` has `import * as foo from ""`. The script asks the language service for completions inside the string.
Clean: only `plain-mod` is offered (pattern modules are excluded).
Injected: the pattern module `*.css` is also offered as a path completion.

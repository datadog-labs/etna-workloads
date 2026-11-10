input.ts uses `in` expressions as defaults inside object/array binding patterns in a `for (var ... of ...)` head.
Clean: the binding pattern re-allows `in`, so parsing succeeds with no syntax errors.
Injected: `in` stays disallowed inside the pattern, so the parser reports false syntax errors.

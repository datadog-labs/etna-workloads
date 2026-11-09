Input: a generic function taking `t: [string, ...T, number]`, reading `t[1]` and destructuring `[c1, c2] = t`.
show.cjs uses the public API to print the checker's type of each declared variable.
Clean: `b` and `c2` are `number | T[number]` (index 1 is within the fixed elements, so it resolves eagerly).
Injected: they stay deferred as `[string, ...T, number][1]`, since the check uses fixedLength instead of the total fixed element count.

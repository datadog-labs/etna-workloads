Input: a CommonJS module with `var` declarations inside the `if`/`else` branches of a top-level `if`, which are exported.
Clean build emits `exports.b = b;` / `exports.c = c;` after each var statement inside the branches.
Injected build visits the branches with the wrong visitor, so the `var` is not hoisted/handled correctly and the export assignments differ.

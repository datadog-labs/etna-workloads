Input: a top-level `if (true)` whose then-branch is an `export const` declaration without initializer (invalid code), compiled to commonjs.
Clean: emits JS with an empty block as the then-statement. Injected: the module transformer hits Debug.checkDefined on the removed statement and crashes (non-zero exit, no output).

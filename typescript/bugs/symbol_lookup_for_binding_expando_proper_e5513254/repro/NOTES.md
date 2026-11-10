Input declares `export function Y(){}` with `Y.test="foo"`, then inside an `if` block a shadowing `const Y = function Y(){}` with `Y.test = 42`.
The binder should look up the expando target in the block scope first. Clean: no errors.
Injected: it looks in the outer container first, so the block-local assignment binds to the outer function Y, giving spurious TS2339/TS2322/TS2741 errors.

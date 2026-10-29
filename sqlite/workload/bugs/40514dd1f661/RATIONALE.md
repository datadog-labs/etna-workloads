# Rationale

## src/expr.c, exprNodeIsConstantFunction()

The fix changed the function to `return WRC_Abort` only when the function is
not constant, and `return WRC_Continue` otherwise. Before the fix, the single
trailing `return WRC_Abort;` ran in both cases.

In 3.54.1 the constant case returns `WRC_Prune`, which has the same effect as
`WRC_Continue` here. The arguments are already walked inside the function.
I restored the old shape: `return WRC_Abort` moved out of the `if` block so it
runs unconditionally, and the `return WRC_Prune` after the block is gone.
`eCode` stays non-zero for a constant function, but the walk stops early, so
sibling expressions are never visited.

## Oracle failure

`values-13.0` fails. In a multi-row VALUES clause,
`VALUES((max(substr('abc',1,1),x)), (123), (456))`, the walk aborts after the
first function call. The other terms are never checked, which gives a wrong
result instead of the expected `xyz`. All other oracle cases pass.

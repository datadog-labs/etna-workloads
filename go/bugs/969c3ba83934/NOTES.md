repro.go: the issue #53650 case (`f[P T1|T2, _ []P]` instantiated as `f[T1]`) plus the g3 call from examples/functions.go.
The bug makes the unifier skip the underlying-type step when the other type is a basic type (`!hasName(x)` instead of `isTypeLit(x)`).
Clean: only reports the `g3` argument error ("cannot use &s1 ... as *myString").
Buggy: also rejects `f[T1]` ("P (type T1) does not satisfy T1 | T2") and reports a different g3 error ("does not match inferred type string for T").

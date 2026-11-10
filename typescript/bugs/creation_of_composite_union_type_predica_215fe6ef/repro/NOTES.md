Calls a union of `(x: unknown) => x is string` and `(x: unknown) => boolean` in an if-condition, then narrows `v: string | number`.
Clean: the `boolean` signature is not `false`-returning, so no composite predicate is made and `v` is not narrowed (errors in both branches).
Injected: non-predicate signatures are ignored, so a bogus predicate `x is string` is created and the narrowing errors disappear.

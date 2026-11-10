Input: an arrow function `(fb: typeof foobar) => fb.type === "foo"` over a discriminated union, used as a guard on `foobar`.
Clean: infers the type predicate `fb is {type:"foo"...}`, so `foobar.foo` narrows and compiles without errors.
Injected: the false-branch check starts from the wrong initial type, so no predicate is inferred and `foobar.foo` reports TS2339.

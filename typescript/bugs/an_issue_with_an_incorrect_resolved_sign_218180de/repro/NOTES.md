Input: two identical nested generic calls `m({ foo: $("foo") })` with `NoInfer`-style mapped parameter; the script prints quick info for `m` and for `$` in each call.
Clean: both `$` quick infos show the same signature `<never, never>(s: never)`.
Injected: the second `$` shows `<"foo", "foo">(s: "foo")` because a wrong resolved signature is cached, so the two calls differ.

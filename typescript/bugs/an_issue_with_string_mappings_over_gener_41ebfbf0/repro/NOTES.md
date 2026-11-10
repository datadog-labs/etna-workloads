Input declares `type A<S> = Lowercase<S & string> extends "foo" ? 1 : 0` and assigns 1 to `A<"foo">`.
Clean build defers the conditional over the generic intersection, so A<"foo"> resolves to 1 and there is no error.
Injected build wrongly resolves it eagerly to 0, reporting TS2322.

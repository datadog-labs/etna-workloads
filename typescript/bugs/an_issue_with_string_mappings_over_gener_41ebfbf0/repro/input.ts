type A<S> = Lowercase<S & string> extends "foo" ? 1 : 0;
let x1: A<"foo"> = 1;

Input: a class with `get` on one line and a generator method `*x() {}` on the next line.
Clean: `get` is a property (ASI after get), `*x(){}` a generator method; no errors, JS emits `get; *x() {}`.
Injected: `get` is treated as an accessor modifier, giving parse errors and different emit.

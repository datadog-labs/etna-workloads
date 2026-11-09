Input uses `using x = fn` where `fn` is a function object with a Symbol.dispose method, then the emitted JS is executed.
Clean: the `__addDisposableResource` helper accepts functions, so it prints "disposed function" and "done".
Injected: the helper only accepts `typeof value === "object"`, so it throws `TypeError: Object expected.` and the script exits non-zero.

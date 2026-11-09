Input: a function returns a const declared with a call-signature type literal whose parameter is `typeof a`, where `a` is narrowed by a typeof guard; the result is called with a string.
Clean: reports TS2345 (string not assignable to number) at `test2(0)?.("")`.
Injected: the binder no longer treats call-signature type literals as flow containers/propagating `this`, so the narrowed type is lost and that error is missing.

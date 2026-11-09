Input: a class method declared with `this: this` and a derived class calling it via `super.m()`.
Clean tsc skips the `this` argument check for super property calls (no error).
Injected tsc only skips it for `new`, so it reports a spurious "'this' context ... not assignable" error.

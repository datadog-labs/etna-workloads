input.ts switches on a parenthesized discriminant `switch ((v.type))` over a `Foo | Bar` union and accesses `v.bar` / `v.foo` in the matching cases.
Clean: the switch expression is unwrapped, so `v` narrows and tsc reports no errors.
Injected: parentheses are not skipped, so `v` is not narrowed and tsc reports TS2339 on `v.bar` and `v.foo`.

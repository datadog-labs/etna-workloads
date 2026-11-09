Expando assignment `Foo[`b`] = ...` on a function using a no-substitution template literal key, then `keyof typeof Foo`.
Clean: `b` is a known property, so `"b"` is accepted and only `"zzz"` errors.
Injected: the template-literal name isn't recognised as a property name, so `Test` differs and the diagnostics differ (e.g. `"b"` is wrongly rejected).

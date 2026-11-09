input.ts aliases a discriminant via a parenthesized initializer (`const k = (obj.kind)`), then narrows `obj` with `if (k === 'a')`.
Clean: the parentheses are skipped, so narrowing works and there are no errors.
Injected: the alias isn't recognized, so `obj.a` / `obj.b` report property-does-not-exist errors.

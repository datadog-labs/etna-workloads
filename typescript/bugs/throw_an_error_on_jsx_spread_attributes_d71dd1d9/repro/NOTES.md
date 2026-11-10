Input spreads a `number` into a JSX element (`<div {...n} />`) and type-checks with `tsc --noEmit --jsx preserve --strict`.
Clean build reports "Spread types may only be created from object types" on the spread expression.
The injected build omits that error and prints no diagnostic.

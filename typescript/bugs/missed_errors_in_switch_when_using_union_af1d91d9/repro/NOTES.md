Switch on a `number | "hello"` expression with cases `true` and `"world"`.
Clean reports TS2678 for `true` ('true' not comparable to 'number | "hello"') and for `"world"`.
Injected compares against base types: message for `true` becomes 'boolean' vs 'string | number', and the `"world"` error is missed.

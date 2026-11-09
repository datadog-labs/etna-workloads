Input is a checkJs file that does `switch (/** @type {"foo"|"bar"} */ (value))` on a `let value = ""` (string), and in `case "bar":` assigns `value` to a variable typed `"bar"`.
Clean: the JSDoc-cast parenthesized expression does not narrow, so `value` stays `string` and TS2322 is reported.
Injected: the cast is treated as a narrowing expression, `value` is narrowed to `"bar"`, and no error is reported.

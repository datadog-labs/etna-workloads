# Re-introduced bug: util.inspect numericSeparator drops sign of negative fractions in (-1, 0)

With `numericSeparator: true`, `formatNumber` computed `string = String(integer)` (`MathTrunc`), which is `"0"` for -0.1234 (the sign is lost), and sliced the fractional part of `String(number)` at `string.length + 1`. For -0.1234 that gives the wrong offset and the output is mangled, e.g. `0..12_34` instead of `-0.123_4`.

## Hunk (lib/internal/util/inspect.js, `formatNumber`)
Corresponds to the fix's second hunk, which added `decimalIndex`/`integerPart`/`fractionalPart` derived from `numberString`. I removed those and restored the old code: `string = String(integer)`, `addNumericSeparator(string)`, and the fractional part from `StringPrototypeSlice(numberString, string.length + 1)`. The release already has `numberString` and an extra `'e'` check, which I kept. The fix's other hunks (renaming to `numberString`) are already in place and harmless.

## Failing test
`parallel/test-util-inspect` fails (stable over repeated runs):
```
+ actual - expected
+ '[ 0.123_4, 0..12, 0..12_3, 0..12_34, -1.234 ]'
- '[ 0.123_4, -0.12, -0.123, -0.123_4, -1.234 ]'
```

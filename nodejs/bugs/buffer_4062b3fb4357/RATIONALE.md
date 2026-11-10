# Rationale

**Bug:** `Blob.prototype.slice` did not coerce `start`/`end` to integers, so non-integer
or odd values (e.g. `blob.slice(0, 1.5)`, BigInt, objects) reached the native slice unconverted instead of getting WebIDL `long long` conversion.

**Change (lib/internal/blob.js):** one hunk removing the `converters['long long'](start/end, {clamp: true})`
calls in `slice()`. This corresponds to the fix's hunk adding `convertToInt('start'/'end', ..., 64, {signed:true})`;
today's code uses `converters['long long']` rather than `convertToInt`, so the removal re-expresses the reversal. The `converters` import is still used elsewhere.

**Failing test:** `parallel/test-blob` (stable over 2 runs):
`AssertionError: Expected values to be strictly deep-equal` — got `Cannot convert a BigInt value to a number`,
expected `start is a BigInt and cannot be converted to a number.`

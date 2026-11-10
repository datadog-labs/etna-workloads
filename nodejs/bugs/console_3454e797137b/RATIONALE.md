# CVE-2022-21824: prototype pollution via console.table

**Bug:** console.table built its column map as a plain object (`{}`). With a column name like `__proto__`, `map['__proto__']` resolved to `Object.prototype`, so `map[key] ??= []` did nothing and `map[key][i] = ...` wrote indices onto `Object.prototype` (pollution). In the old behaviour this could also throw.

**Hunk:** `lib/internal/console/constructor.js`, `const map = { __proto__: null };` changed to `const map = {};`. This corresponds to the fix's `const map = ObjectCreate(null)` hunk. Today's code uses the `{ __proto__: null }` literal instead of `ObjectCreate`. The fix's `ObjectCreate` import hunk has no equivalent, because the file no longer imports it.

**Failing test:** `parallel/test-console-table` fails with `TypeError: Cannot create property '0' on string ''`. The failure was the same on two runs. It comes from the `['__proto__']` regression case.

# Rationale

**Bug:** `performance.getEntriesByName()` / `getEntriesByType()` called with no argument did not throw
ERR_MISSING_ARGS; the missing argument stayed `undefined`, which disabled the filter so ALL entries were returned.
Also `undefined` was not stringified, so `getEntriesByName(undefined)` did not match an entry named "undefined".

**Change (lib/internal/perf/performance.js)**, corresponding to both hunks of the fix (re-expressed for the class methods of today's code):
- `getEntriesByName`: removed the `arguments.length === 0` ERR_MISSING_ARGS throw and the unconditional `name = \`${name}\``; restored `if (name !== undefined) name = \`${name}\``.
- `getEntriesByType`: same, for `type`.

**Failing test:** parallel/test-performance-timeline (`not ok`; the `getEntriesByName(undefined).length === 1` assertion and the missing-ARGS `assert.throws` checks fail). Stable over two runs.

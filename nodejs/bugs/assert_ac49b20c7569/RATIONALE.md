# Re-introduced bug: assert.deepEqual always true for URL objects

**Bug:** `assert.deepEqual`/`deepStrictEqual` had no URL-specific comparison. URL state lives in internal slots, so there are no own enumerable keys and two different URLs (e.g. `http://foo` and `http://bar`) compared equal.

**Change (lib/internal/util/comparisons.js):**
1. Removed the `else if (isURL(val1)) { if (!isURL(val2) || val1.href !== val2.href) return false; }` branch from `innerDeepEqual`. Corresponds to the fix's hunk adding that branch (the fix placed it after the WeakMap/WeakSet branch; in today's code it sits after the boxed-primitive branch).
2. Removed the now-unused `const { isURL } = require('internal/url');` import, matching the fix's import hunk.

The inspect.js hunk of the fix (URL formatting in util.inspect) is not reverted. It only affects the assertion message, and the release has since changed that area.

**Failing test:** `parallel/test-assert-deep` fails ("not ok 1"), because the URL cases such as `assertNotDeepOrStrict(new URL('http://foo'), new URL('http://bar'))` no longer see a difference.

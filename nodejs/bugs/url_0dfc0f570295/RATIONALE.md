# Rationale

**Bug:** Before upstream fix 0dfc0f5, WHATWG URL accessors were defined through property descriptors (`get() {}` / `set() {}`), so their function names were `"get"`/`"set"` rather than `"get href"`/`"set href"` as browsers expose.

**Change (lib/internal/url.js):** The release already uses class syntax (the fix's main hunks were already applied and have since been rewritten with private fields), so the plain reversal does not apply. I re-expressed the old pattern for one accessor, `URL.prototype.href`. This corresponds to the fix's hunk that turns the `href: { get(), set() }` descriptor into class `get href()`/`set href()`.
- I removed the class `get href`/`set href`.
- I re-added them as `get()`/`set()` in a descriptor, set up in a `static {}` block so they can still reach the `#context` private field.
- I added the `ObjectDefineProperty` import.

**Failing test:** `parallel/test-whatwg-url-properties` fails with `AssertionError: 'get' !== 'get href'`. It failed on both runs I did with the final build.

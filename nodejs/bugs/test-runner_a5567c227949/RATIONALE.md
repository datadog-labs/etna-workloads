# Rationale

**Bug:** `require('node:test/reporters').spec` was exposed as a getter returning the raw `SpecReporter` class. Calling `spec()` without `new` therefore throws `TypeError: Class constructor SpecReporter cannot be invoked without 'new'`. The fix made it a newable function that uses `ReflectConstruct`, so both `new spec()` and `spec()` work.

**Hunk (lib/test/reporters.js, `spec` property):** this corresponds to the fix's single implementation hunk. In today's code the property is `value: function spec() { specFn ??= require(...); return ReflectConstruct(specFn, arguments); }`. I changed it back to `get() { specFn ??= require(...); return specFn; }`, the pre-fix behaviour. `ReflectConstruct` is still used by `lcov`, so the primordials import stays. The fix's other changes were tests, which I did not touch.

**Failing test:** `parallel/test-runner-run`. The subtest `spec()` fails with `TypeError: Class constructor SpecReporter cannot be invoked without 'new'`. I ran it three times (once in the build step, twice more afterwards) and it failed each time.

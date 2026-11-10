# Re-introduced bug: unintentional domain deprecation warning

**Bug.** `callbackTrampoline` in `lib/internal/async_hooks.js` calls the domain hook callback (`domain_cb`) on every callback. The callback is only needed when no async_hooks integration is in use (asyncId === 0), and the deprecation warning is emitted along with it. Using it unconditionally makes domain users see a spurious deprecation warning.

**Hunk (lib/internal/async_hooks.js).** The fix changed `if (typeof domain_cb === 'function')` to `if (asyncId === 0 && typeof domain_cb === 'function')`. I removed the `asyncId === 0 &&` guard. The fix's other hunks (`asyncId &&` → `asyncId !== 0 &&`) are style-equivalent, and the current code already has the `!== 0` form, so I didn't touch them.

**Failing tests** (each has `process.on('warning', common.mustNotCall())`): parallel/test-domain-implicit-binding, test-domain-multi, test-domain-promise, test-domain-implicit-fs. They fail because a warning is emitted unexpectedly. test-domain-http-server still passes.

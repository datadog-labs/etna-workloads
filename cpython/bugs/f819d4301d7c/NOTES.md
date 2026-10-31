# NOTES

`repro.py` is a translation of the upstream regression test
`test.test_asyncio.test_futures.CFutureDoneCallbackTests.test_use_after_free_on_fut_callback_0_with_evil__getattribute__`
added by `fix.patch` (gh-125984), targeting the C `_asyncio.Future`
implementation where the bug lives.

It creates a `_CFuture` whose event loop (`EvilEventLoop`) overrides
`__getattribute__`: the very first time the C code in
`future_schedule_callbacks()` reads the loop's `call_soon` attribute (in
order to invoke it), the override calls
`fut.remove_done_callback(fut_callback_0)` and then `del fut_callback_0`,
dropping the only remaining Python reference to the callback object. Only
after that does `__getattribute__` return the real `call_soon` bound method,
which raises `ReachableCode` to prove it was reached with the callback
still alive according to the (by-then-stale) C pointers.

- On `python-clean` (fixed): `future_schedule_callbacks()` first transfers
  `fut->fut_callback0`/`fut_context0` into local C variables and clears the
  struct fields *before* looking up/calling `call_soon`, so the evil
  `__getattribute__` cannot free an object that `call_soon` is still about
  to use. `call_soon` runs, raises `ReachableCode`, which `fut.set_result()`
  lets propagate. Output is deterministic: `ReachableCode raised` then
  `done`, exit status 0.
- On `python-buggy` (`injection.patch` applied): `future_schedule_callbacks()`
  instead reads `fut->fut_callback0`/`fut_context0` directly and only clears
  them *after* calling `call_soon`. Looking up `call_soon` triggers the evil
  `__getattribute__`, which removes/frees the only reference to the callback
  object while the C code still holds the now-dangling `fut->fut_callback0`
  pointer and is about to pass it to `call_soon`. This is a use-after-free;
  on this pydebug build it reliably segfaults (exit status -11 / SIGSEGV)
  instead of printing anything.

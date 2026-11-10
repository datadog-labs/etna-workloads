# Re-introduced bug: wasi: throw on failed uvwasi_init()

**Bug:** If `uvwasi_init()` fails (e.g. a preopen path that does not exist), the `WASI` constructor in `src/node_wasi.cc` aborts the whole process via `CHECK_EQ(..., UVWASI_ESUCCESS)` instead of throwing a JS exception.

**Hunk (src/node_wasi.cc, WASI::WASI):** corresponds to the fix's constructor hunk. The current code checks `err != UVWASI_ESUCCESS` and throws the exception built by `WASIException`. I restored the original `CHECK_EQ(uvwasi_init(&uvw_, options), UVWASI_ESUCCESS);`. The `WASIException` helper hunk from the fix is left in place, because the fix added it and removing it would be a separate change. It is now unused, so the build prints an unused-function warning. The build still succeeds.

**Failing test:** `wasi/test-wasi-options-validation` reports `not ok`. The process aborts with `Assertion failed: (uvwasi_init(&uvw_, options)) == (0)` when running `new WASI({ preopens: { '/sandbox': '__/not/real/path' } })`. It fails the same way on both runs.

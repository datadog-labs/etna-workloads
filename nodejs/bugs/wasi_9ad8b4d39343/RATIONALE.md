# Re-introduced bug: wasi accepts only same-context WebAssembly.Instance/Memory

**Bug.** `WASI.start()` (and `initialize()`) type-checked their input with `instanceof WebAssembly.Instance` and `instanceof WebAssembly.Memory`. Objects created in another VM context (e.g. `vm.runInNewContext`) have a different set of built-in globals, so they failed the check even though they were valid.

**Change (lib/wasi.js, one logical hunk in `finalizeBindings`, plus import/global housekeeping).**
- Replaced `validateObject(instance, 'instance')` with `instanceof WebAssembly.Instance`, throwing `ERR_INVALID_ARG_TYPE`. This corresponds to the fix's `start()` hunk, which removed that check. The check now lives in `finalizeBindings`, which is where today's code does the validation.
- Added `instanceof WebAssembly.Memory` on `memory`. This corresponds to the fix's second hunk, which replaced it with an object check plus an `isArrayBuffer(memory.buffer)` check.
- Added the `/* global WebAssembly */` comment and the `ERR_INVALID_ARG_TYPE` import, which the old code needed. These mirror the fix's removal of the global comment and its added imports.

The C++ `_SetMemory` uses `IsWasmMemoryObject()`, which was already in the release, so I left it unchanged.

**Failing test.** `wasi/test-wasi-start-validation` fails with `not ok`, and the failure was the same on both runs. The expected message was `/"instance" argument must be of type object/`. The actual message was `The "instance" argument must be an WebAssembly.Instance. Received undefined`. The cross-context and duck-typing cases would also be rejected.

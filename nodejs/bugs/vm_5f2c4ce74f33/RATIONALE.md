# Re-introduced bug: vm.measureMemory() promise never resolves

**Bug.** `vm.measureMemory()` created a `v8::MeasureMemoryDelegate` and a promise resolver but never called `v8::Isolate::MeasureMemory()`. The returned promise therefore never resolves.

**Change (src/node_contextify.cc, `MeasureMemory`).** This corresponds to the fix hunk that added `isolate->MeasureMemory(std::move(delegate), static_cast<v8::MeasureMemoryExecution>(execution))`. I replaced that call with `USE(delegate); USE(execution);`. The delegate is created but never handed to V8, which is the pre-fix behaviour. The `USE()` calls only keep the build warning-free.

The other fix hunks (the `execution` option in lib/vm.js, the constants, and removing the `context` option) had already landed in the release. Reverting them is not needed to bring the bug back, so I left them alone.

**Failing tests** (all three oracle cases): parallel/test-vm-measure-memory, parallel/test-vm-measure-memory-lazy, parallel/test-vm-measure-memory-multi-context. They fail because the `common.mustCall()` handlers on the promise never run, so the process exits with the mustCall "Mismatched ... function calls. Expected exactly 1, actual 0" error.

# Re-introduced bug: crash in SyntheticModule#setExport

**Bug.** `ModuleWrap::SetSyntheticExport` (src/module_wrap.cc) used the old V8 API, which crashed
the process instead of throwing when `setExport` failed (e.g. exporting a name that was not declared,
which should throw a `ReferenceError`; V8 issue 9828).

**Change (one hunk, src/module_wrap.cc).** Corresponds to the fix's single implementation hunk
(`USE(module->SetSyntheticModuleExport(isolate, ...))`). The old V8 overload no longer exists, so the
plain reversal can't build. I replaced `USE(...)` with `.Check()` on the returned `Maybe<bool>`.
When V8 reports failure (Nothing, exception pending), the process aborts with
`FATAL ERROR: v8::FromJust Maybe value is Nothing`. This is the original crash behaviour in place of
propagating the JS exception.

**Failing test.** `parallel/test-vm-module-synthetic` (not ok, stable across 2 runs):
`FATAL ERROR: v8::FromJust Maybe value is Nothing` (the setExport-on-undeclared-name case).

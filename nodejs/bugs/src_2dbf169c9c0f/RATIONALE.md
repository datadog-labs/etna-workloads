# Re-introduced bug (nodejs/node#42962)

**Bug:** In the vm contextify global-proxy named setter, assigning to a property that is an accessor (get/set) on the sandbox did not tell V8 the store was intercepted. V8 then went on to also define or assign the property on the real global object, so the assignment could throw (`TypeError: Cannot redefine property`) or double-apply, instead of just running the sandbox's setter.

**Change (src/node_contextify.cc, `PropertySetterCallback`):** I removed the final block that looked up the sandbox property descriptor and returned `Intercepted::kYes` when it had `get` or `set`. The callback now always returns `Intercepted::kNo` after `sandbox->Set(...)`.
This corresponds to the fix's single implementation hunk. The fix made the setter always signal V8 that the property was intercepted. The old code did not signal it. The release has a different shape (the `Intercepted` return type replaced `args.GetReturnValue().Set(...)`), so I re-expressed it as removing the conditional `kYes` path. The fix's removed strict-mode `Set(false)` hunk is not needed in the old behaviour as re-expressed.

**Failing test:** `parallel/test-vm-global-setter` fails with
`TypeError: Cannot redefine property: getSetPropReceivingFunction` at test line 85. It failed on both runs.

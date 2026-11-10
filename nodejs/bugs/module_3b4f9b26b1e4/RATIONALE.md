# Re-introduced bug: ModuleWrap::Link refuses to override linked requests

## Bug
`ModuleWrap::Link` threw `ERR_VM_MODULE_LINK_FAILURE` ("module is already linked") if the
module's linked-requests internal slot was already set. `vm.SourceTextModule.link()` with an
async linker and shared dependencies could call `moduleWrap.link` a second time on the same
wrap (because of the `statusOverride` race), which then threw instead of being tolerated.

## Change (src/module_wrap.cc, `ModuleWrap::Link`)
Single hunk, corresponding to the fix's hunk that removed the guard (and the now-needed
`Realm* realm = Realm::GetCurrent(args);`, which already exists in today's code, so it needed
no re-adding). I re-added the check of `kLinkedRequestsSlot` that throws
"module is already linked" right after `CHECK_EQ(args.Length(), 1)`, restoring the pre-fix behaviour.

## Failing test
`parallel/test-vm-module-link-shared-deps` fails (run twice, stable):
`Error: module is already linked`.

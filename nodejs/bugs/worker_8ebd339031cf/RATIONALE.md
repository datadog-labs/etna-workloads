# Re-introduced bug (upstream 8ebd339031)

Bug: context-aware addons that self-register via static constructor (NODE_MODULE) could not be loaded
a second time from another Environment (worker / second load of the same shared object), because
the module pointer registered on the first dlopen was not remembered. The second load found no pending
module and threw "Module did not self-register". N-API modules registered by napi_module_register also leaked
their heap-allocated node_module (no NM_F_DELETEME).

Hunks:
1. src/node_binding.cc, DLOpen fallback branch: the fix added `mp = dlib->GetSavedModuleFromGlobalHandleMap()`
   and only errors if that yields nothing/non-context-aware. Reverted to the pre-fix behaviour: always close and
   throw "Module did not self-register". (The global handle map is left in place but never consulted.)
2. src/node_api.cc napi_module_register: dropped `| NM_F_DELETEME` from nm_flags (fix hunk 1), restoring the leak.

Failing test: addons/worker-addon/test (stable over 2 runs):
`Error: Module did not self-register: '.../worker-addon/build/Release/binding.node'.` in the 'both' / 'worker-twice' scenarios
(expected stdout 'ctor cleanup cleanup dtor ' but stderr contains the error).
Other oracle tests still pass.

Reproducer: swaps `PyImport_Inittab` (via ctypes) for a table that also contains a dotted
name `pkg.sub`, then calls `_imp.create_builtin()` for that name. This mirrors the embedding
tests, which register `pkg.submod` with `PyImport_AppendInittab`.

Clean: prints `ModuleNotFoundError pkg.sub module not found`, exit 0.
Buggy: aborts on the re-added assert in `_Py_ext_module_loader_info_init_for_builtin`
(`Python/importdl.c:159`, name must not contain '.'), exit -6.

The clean interpreter reports "not found" rather than loading the module. The reproducer
doesn't try to build a working extension module, because the assert fires before the init
function is called.

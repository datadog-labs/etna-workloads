# Rationale

The atomic accessors already exist in v3.15.2, so only the placement of the flag store is reverted.

Changed file: `tree/Python/pylifecycle.c`, in `init_interp_main()`.

- Fix hunk "`- interp->runtime->initialized = 1;` after the warnoptions block": re-added as
  `_PyRuntimeState_SetInitialized(interp->runtime, 1)` at the end of the `if (is_main_interp)` warnings block, before the `site` import.
- Fix hunk "`+ if (is_main_interp) { _PyRuntimeState_SetInitialized(...,1); }` at the end of the function": removed.

`Py_IsInitialized()` therefore returns true again while `site` is being imported. This is the pre-fix behaviour.

Oracle: `test.test_embed.EmbeddingTests.test_isinitialized_false_during_site_import` fails with
`ERROR: Py_IsInitialized() was true during site import`.

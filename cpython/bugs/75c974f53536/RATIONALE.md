# RATIONALE

Fix: gh-104621 moved the `_PyImport_CheckSubinterpIncompatibleExtensionAllowed()` call
into `import_find_extension()` so a cached single-phase extension is rejected before it is reloaded.

Changes in `Python/import.c` (the check is removed from the cache-hit path):

1. `import_find_extension()`: removed the check added by the fix's first `import.c` hunk.
2. `reload_singlephase_extension()`: removed the equivalent check, which covers the same case from
   another path. `name_buf` is still declared because later code in that function uses it.
   This is the same defect, so the bug is not fixed twice.
3. `_imp_create_dynamic_impl()`: the fix's second hunk deleted the post-lookup check. That
   check is already absent in v3.15.2, so no change was needed there.

With the checks gone, a cached single-phase module is handed to a subinterpreter that forbids
legacy modules, so a second import succeeds.

Oracle cases that now fail:
- `SubinterpImportTests.test_disallowed_reimport`: the second `run_string` no longer fails.
- `test_single_init_extension_compat` and `test_singlephase_check_with_setting_and_override`:
  the incompatible extension is imported again.

The other failing cases (`test_import`, `PycacheTests.*`) fail in this sandbox only because
the site-packages directory is read-only. They are unrelated to this change.

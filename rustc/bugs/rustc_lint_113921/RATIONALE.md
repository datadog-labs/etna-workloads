# Adapted injection for lint/ctypes: only try normalize

Fix: https://github.com/rust-lang/rust/commit/09434a2575cee12b241c516ad91f21d4b4f9c3fd

# Hunks
compiler/rustc_lint/src/types/improper_ctypes.rs, `maybe_normalize_erasing_regions`: now calls
`tcx.normalize_erasing_regions(typing_env, value)` (panics on failure) instead of
`try_normalize_erasing_regions(..).unwrap_or(value)`.
Re-expresses all three fix.diff hunks (types.rs @@ -966, -1320, -1339), which replaced
`normalize_erasing_regions` with `try_normalize_erasing_regions(...).unwrap_or(ty)`. In 1.99.1 those
call sites were consolidated into this helper.

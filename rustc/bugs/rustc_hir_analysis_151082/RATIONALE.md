# Adapted injection for Silence unused type param and inference errors on struct parse error

Fix: https://github.com/rust-lang/rust/commit/9750d22c17092fa747e088ae24bb749077edefa9

# Rationale
Only one hunk changed: compiler/rustc_hir_analysis/src/check/wfcheck.rs, `report_bivariance`.
Re-expresses fix hunk `@@ -2160,7 +2160,12 @@ fn report_bivariance<'tcx>(`: the fix replaced `diag.emit()` with
`if item.kind.recovered() { diag.delay_as_bug() } else { diag.emit() }`. I restored the unconditional `diag.emit()`,
so E0392 (unused type parameter) is emitted again for structs with a parse error.
The hir.rs hunk (`ItemKind::recovered`) is left in place (applies cleanly, harmless helper). The need_type_info.rs hunk was not reverted (its context moved; the wfcheck revert alone makes the oracle fail).

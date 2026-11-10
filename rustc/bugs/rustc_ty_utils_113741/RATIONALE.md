# Adapted injection for Don't install default projection bound for RPITITs

Fix: https://github.com/rust-lang/rust/commit/0f0ab89feb4d668cb989aefe08f27af45cb10bed

# Rationale
Only hunk changed: compiler/rustc_ty_utils/src/ty.rs, `param_env`. Removed the
`&& let assoc_item = ...` / `&& assoc_item.defaultness(tcx).has_value()` condition so
ImplTraitInTraitFinder installs projection bounds for RPITITs in non-defaulted trait methods too.
Re-expresses fix hunk `@@ -129,7 +129,9 @@ fn param_env` (added `assoc_item.defaultness(tcx).has_value()`).
The encoder.rs hunk (always encode RPITIT types) was not re-injected; the ty.rs hunk alone fails the oracle.

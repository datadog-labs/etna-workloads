# Adapted injection for Don't perform selection if IATs are not enabled

Fix: https://github.com/rust-lang/rust/commit/838f85d6f7f5d6c5bff1dad5ef9116c5749a122b

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `probe_inherent_assoc_item`.
Fix hunk `@@ -1893,6 +1893,15 @@ ... ` added "if !tcx.features().inherent_associated_types { return Ok(None); }" ("Don't attempt to look up inherent associated types when the feature is not enabled").
In 1.99.1 that early return is the `ty::AssocTag::Type => return Ok(None),` arm; changed to `ty::AssocTag::Type => {}` so selection runs even with the feature disabled (old behaviour).

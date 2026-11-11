# Adapted injection for Reword diagnostic about relaxing non-`Sized` bound

Fix: https://github.com/rust-lang/rust/commit/879f62bb3c23b7a90ac71bb217056fd49ff8dafb

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, fn `check_and_report_invalid_relaxed_bounds` (the error emitted for `?Trait` on non-Sized traits).
The fix's errors.rs hunk (`@@ -62,...`) replaced the old message "relaxing a default bound only does something for `?Sized`; all other traits are not bound by default" with "bound modifier `?` can only be applied to `Sized`". On 1.99.1 the code has moved/been reworded, so I restored the old long message in place of the conditional new wording. The rename hunks (collect_unbounds) are cosmetic and not reverted.

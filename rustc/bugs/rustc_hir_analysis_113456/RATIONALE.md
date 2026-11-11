# Adapted injection for Avoid calling report_forbidden_specialization for RPITITs

Fix: https://github.com/rust-lang/rust/commit/24326ee5081a28628f0046d25764408b7bf4e2ca

# check.rs, check_specialization_validity
Re-expresses hunk `@@ -722,7 +722,14 @@ check_specialization_validity`: removes the guard
`if !tcx.is_impl_trait_in_trait(impl_item)` and the `else { delayed_bug(...) }` branch, so the
forbidden-specialization error (E0520) is always emitted, including for RPITIT/async-fn-in-trait items.
(The second fix hunk is formatting only; not changed.)

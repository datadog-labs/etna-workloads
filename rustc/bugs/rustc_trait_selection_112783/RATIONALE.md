# Adapted injection for Don't ICE on bound var in reject_fn_ptr_impls

Fix: https://github.com/rust-lang/rust/commit/29c74d561992c156cec01119ef4e70766efa013c

Hunk: compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs, `reject_fn_ptr_impls`.
Re-expresses fix hunk `@@ -417,17 +417,15 @@`: the fix moved `ty::Bound(_, _)` into the "may potentially implement FnPtr" arm and removed the `span_bug!("cannot have escaping bound var in self type ...")`. I restored the separate `ty::Bound` arm with that span_bug!, so a bound var self type (for<T> T: ...) ICEs.

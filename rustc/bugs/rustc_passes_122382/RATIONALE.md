# Adapted injection for Detect unused structs which implement private traits

Fix: https://github.com/rust-lang/rust/commit/96968350e17efdbb9958dbeaec4982d8cca0019d

# Rationale
File compiler/rustc_passes/src/dead.rs, fn `MarkSymbolVisitor::check_impl_or_impl_item_live` (the 1.99.1 successor of `impl_item_with_used_self`/`solve_rest_impl_items`).
Added condition `trait_def_id.is_none_or(|id| tcx.visibility(id).is_public()) &&` before the "self ADT must be live" check. So only impls of public traits require a used self type; items of private traits are live whenever the trait (item) is live, even if the struct is never constructed.
This re-expresses fix hunk `@@ -425,10 +425,11 @@` (removal of `self.tcx.visibility(trait_id).is_public() &&`, i.e. before the fix only public traits got the private-self-type treatment) and the `@@ -485,32 +486,46 @@` change that made private methods require self to be live.

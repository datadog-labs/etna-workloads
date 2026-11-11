# Adapted injection for Fix const specialization

Fix: https://github.com/rust-lang/rust/commit/9bda88bb58c1c6fa175166a7d5272f483eac38c8

# Rationale
File: compiler/rustc_trait_selection/src/traits/specialize/mod.rs, fn `specializes`.
Removed the check `if !tcx.is_conditionally_const(specializing_impl_def_id) { return false; }` inside
`if tcx.is_conditionally_const(parent_impl_def_id)`. Re-expresses fix hunk
`@@ -339,8 +345,14 @@ pub(super) fn specializes(` which added exactly that check. Without it, a non-const
specializing impl is accepted as specializing a const parent impl (the original bug).
Other fix hunks (removing check_constness in min_specialization.rs) are not reversed: they were removal of a now-redundant check and 1.99.1 no longer has it.

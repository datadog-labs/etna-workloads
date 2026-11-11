# Adapted injection for Restrict param constraint suggestion

Fix: https://github.com/rust-lang/rust/commit/3bbc70a5f72a8e54e50d981c01d748d3d9087b5d

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/note_and_explain.rs (constrain-suggestion fn, formerly rustc_infer/.../note_and_explain.rs).
Removed the block
`if (param_ty.index as usize) >= generics.parent_count { // The param comes from the current item, do not look at the parent. (#117209) return false; }`
which re-expresses the fix hunk `@@ -390,6 +389,10 @@` (added the early return). The earlier refactor hunk (let-else) is behaviour-neutral and was not reverted.

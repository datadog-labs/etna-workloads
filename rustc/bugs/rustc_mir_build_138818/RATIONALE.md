# Adapted injection for Don't produce debug information for compiler-introduced-vars when desugaring assignments.

Fix: https://github.com/rust-lang/rust/commit/8cab8e07bc94fb2fea8e1421d2d2e6de6398b69b

# Rationale
File: compiler/rustc_mir_build/src/builder/matches/mod.rs

- `declare_binding`: removed the `if self.should_emit_debug_info_for_binding(name, var_id)` guards so VarDebugInfo is pushed unconditionally for both `for_arm_body` and `ref_for_guard`. Re-expresses fix hunk `@@ -2796,13 +2796,15 @@ ... declare_binding` (which added the guard around `self.var_debug_info.push(VarDebugInfo { name, ...`) and the matching guard hunk at 2829.
- Removed helper `should_emit_debug_info_for_binding` (skipped debug info for `lhs` bindings in `LocalSource::AssignDesugar` lets), and its now-unused imports `LetStmt, LocalSource, Node, sym`: re-expresses hunk `@@ -13,13 +13,13 @@` (imports) and the added helper.

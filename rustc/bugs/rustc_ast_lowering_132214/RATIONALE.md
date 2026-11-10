# Adapted injection for Move an impl-Trait check from AST validation to AST lowering

Fix: https://github.com/rust-lang/rust/commit/442f39582d2aec5026c8d75079a75f58579059e4

# Rationale
1. compiler/rustc_ast_lowering/src/path.rs `lower_qpath`: reverts fix hunks 1-4 (`@@ -34,7 +34,10 @@`, `@@ -75,6 +78,16 @@`, `@@ -121,7`, `@@ -185,7`): qself lowered with caller's `itctx` again (not `Disallowed(Path)`); removed the `let itctx = |i| ...` closure restricting impl Trait to the final segment; `itctx(i)` -> `itctx`.
2. compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs (code moved from mod.rs): re-adds the `else if let ty::Alias(Opaque..)` E0667 "`impl Trait` is not allowed in path parameters" branch, which the fix removed in `@@ -1203,15 +1203,6 @@` of hir_ty_lowering/mod.rs.
The ast_passes validation hunks (already gone in 1.99.1) were not re-added.

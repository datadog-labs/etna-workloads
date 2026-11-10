# Adapted injection for Add ignore value suggestion in closure body

Fix: https://github.com/rust-lang/rust/commit/3d50334314cb41f2334f201458d4be0aa15ae203

# Rationale
1. compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, `suggest_missing_semicolon`: removed the
   `ExprKind::Path(..) | ExprKind::Lit(_) if parent_is_closure` arm that suggests `_ = ` (fix hunk
   `@@ -789,6 +790,18 @@` which added "consider ignore the value here"). The `parent_is_closure` param is kept
   (renamed `_parent_is_closure` to avoid unused warning).
2. compiler/rustc_hir_typeck/src/coercion.rs, `report_return_mismatched_types`: restored the
   `&& !matches!(body.value.kind, Block(..))` guard on the closure-parent suggestion call
   (fix hunk `@@ -1891,9 +1891,10 @@`, which replaced it with `needs_block` computed and passed in), so
   closures with block bodies get no suggestion call.

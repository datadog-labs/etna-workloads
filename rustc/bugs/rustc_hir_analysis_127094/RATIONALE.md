# Adapted injection for E0191 suggestion correction, inserts turbofish without dyn (#91997)

Fix: https://github.com/rust-lang/rust/commit/7c88bda1cb9a454ebce2f84ce188e950272a12c0

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs, fn complain_about_missing_assoc_item_ty (E0191 reporting; code moved from old `complain_about_missing_associated_types`).
Removed the `in_expr_or_pat` computation (grandparent HIR node Expr/Pat check) and the `else if in_expr_or_pat { format!("{}::<{}>", ...) }` suggestion branch, so the suggestion is always `Trait<Item = ..>` even in expression/pattern position.
Re-expresses fix hunks `@@ -745,7 +745,15 @@` (the `in_expr_or_pat` computation) and `@@ -901,6 +909,10 @@` (`} else if in_expr_or_pat { ... format!("{}::<{}>" ...`).
The `use` hunk (`Node` import) is not needed as 1.99.1 uses `hir::Node`.

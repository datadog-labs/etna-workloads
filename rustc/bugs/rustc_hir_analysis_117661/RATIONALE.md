# Adapted injection for Point out shadowed associated types

Fix: https://github.com/rust-lang/rust/commit/3234418806de31db283a00fbcf70cd2857c9a81e

# Rationale
All changes in compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs (`report_missing_assoc_items`-style E0191 reporter; file moved from astconv/errors.rs).
- Loop over missing_assoc_items: removed `shadows` flag, the `else if bound_names...` branch (fix hunk `@@ -621,16 +648,42 @@` "+ let mut shadows = false; ... } else if bound_names.get(&item.name).is_some_and(...)"), removed the "`X` shadowed here, consider renaming it" label and the ", consider renaming it" suffix on "defined here" label.
- Suggestion condition: `(Ok(snippet), false, false)` back to `(Ok(snippet), false)` (hunk `@@ -638,8 +691,8 @@`), so a bogus `Item = Type` suggestion is emitted when shadowing.
- bound_names computation (hunk `@@ -581,6 +582,32 @@`) is left but renamed `_bound_names` (unused) to keep the build warning-free.

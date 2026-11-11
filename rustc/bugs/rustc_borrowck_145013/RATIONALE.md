# Adapted injection for overhaul `&mut` suggestions in borrowck errors

Fix: https://github.com/rust-lang/rust/commit/4335405fa7c709b2733c6121fbf4bc0d8e291dcc

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mutability_errors.rs, fn `suggest_ampmut`.
Removed the `if let Either::Right(call) = body.stmt_at(*assign) && ... is_lang_item(trait_, LangItem::Index)` block, which checks whether the type implements `IndexMut`, suggests `get_mut` for BTreeMap/HashMap, and otherwise returns `None` (no `&mut` suggestion).
This re-expresses the fix hunk `@@ -1501,54 +1489,101 @@ fn suggest_ampmut<'tcx>(` (and the related `@@ -1131,273 +1128,257 @@` overhaul), which added IndexMut-aware handling. Before the fix, `&mut` was suggested even for Index-only types and no `get_mut` suggestion existed.

# Adapted injection for Suggest relaxing implicit `type Assoc: Sized;` bound

Fix: https://github.com/rust-lang/rust/commit/e8d4fb8aaafa598d3021f2378705f780ee173458

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn note_obligation_cause_code (in the `Sized` lang-item branch).
Removed the `if let Some(hir::Node::TraitItem(.. kind: TraitItemKind::Type(bounds, None) ..)) ... err.span_suggestion_verbose(..."consider relaxing the implicit `Sized` restriction"...)` block.
This re-expresses the fix hunk `@@ -2652,6 +2652,29 @@ impl<'tcx> TypeErrCtxtExt<'tcx> for TypeErrCtxt` that added that block (the code moved from traits/error_reporting/ to error_reporting/traits/ in 1.99.1).

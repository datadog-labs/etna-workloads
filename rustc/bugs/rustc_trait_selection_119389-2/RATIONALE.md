# Adapted injection for Provide more context on recursive `impl` evaluation overflow

Fix: https://github.com/rust-lang/rust/commit/2c2f3ed2c4a99d6d2bc4c1a45890146c7b0c8561

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traces/suggestions.rs (path: error_reporting/traits/suggestions.rs), fn note_obligation_cause_code, ImplDerived arm for `Node::Item(Impl)`.
Removed the call to `point_at_assoc_type_restriction(tcx, err, &self_ty_str, &trait_name, predicate, &generics, &data)`, re-expressing the fix hunk `@@ -3561,6 +3557,15 @@` (which added that call after `err.span_note(spans, msg);`). The helper (and SelfVisitor) stay, marked `#[allow(dead_code)]`, plus a `let _ = (...)` to avoid unused warnings. Result: the E0275 on impl cycles lacks the "associated type specified here" label, the removal/replacement suggestions and the "cannot be restricted in where clauses" note.

# Adapted injection for While let suggestion will work for closure

Fix: https://github.com/rust-lang/rust/commit/9aed9697cf0c5042b0465b06071b2508e7884d2a

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/suggest.rs, fn `suggest_let_for_letchains`.
Fix hunk `@@ -464,52 +464,53 @@ impl<'tcx> TypeErrCtxt<'_, 'tcx>` replaced
`if let Some(node) = find_by_def_id(cause.body_id) && let Node::Item(Item{kind: ItemKind::Fn(..)})`
with `maybe_body_owned_by(cause.body_id)`, so closures' bodies are also searched.
I re-introduced the old behaviour: the body is only looked up when the owner node is an `Item` of kind `Fn`; otherwise (e.g. closures) returns None, so no "consider adding `let`" suggestion.

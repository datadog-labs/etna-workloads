# Adapted injection for Avoid to suggest pattern match on the similarly named in fn signature

Fix: https://github.com/rust-lang/rust/commit/e9a45e66461f3c324a249d7352eb2f4d184a6b2a

# Rationale
File: compiler/rustc_mir_transform/src/liveness.rs, closure `maybe_suggest_typo` (liveness moved here from rustc_passes).
Fix hunk `@@ -1691,7 +1691,10 @@ impl<'tcx> Liveness` added a filter `!matches!(parent_hir_node(hir_id), Node::Param(_))` so
function parameters get no "pattern match on similarly named" suggestion. In 1.99.1 the equivalent is the
`if let LocalKind::Arg = self.body.local_kind(local) { None } else {...}` guard; I removed it so params get the typo suggestion again (the old bug).

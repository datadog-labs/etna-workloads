# Adapted injection for fix the span in the suggestion of remove question mark

Fix: https://github.com/rust-lang/rust/commit/2195fa6a9bad1e95511875c93c34b55fe7ae55fa

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, `note_error_origin`, arm `ObligationCauseCode::BlockTailExpression(_, MatchSource::TryDesugar(scrut_hir_id))`.

Fix hunk (`@@ -764,7 +764,7 @@ impl<'tcx> TypeErrCtxt`): `source_map.end_point(cause.span)` -> `source_map.end_point(cause.span())`, so the "try removing this `?`" suggestion uses the correct span and not the enclosing paren expression.
In 1.99.1 `cause.span()` no longer exists (it is a plain field), and the code moved from rustc_infer to rustc_trait_selection. To bring back the old wrong span, the suggestion now uses the span of the parent HIR node of the `?` desugar (the paren expr `(x?)`), so `end_point` hits `)` instead of `?`, giving `(x?`.

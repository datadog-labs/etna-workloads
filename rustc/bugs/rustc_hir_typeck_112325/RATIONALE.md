# Adapted injection for diagnostics: do not suggest type name tweaks on type-inferred closure args

Fix: https://github.com/rust-lang/rust/commit/467bc9ffd56dc31d6db79820bd07dbdd5f653783

# Rationale
The fix made closure params without type ascription pass `SizedArgumentType(None)` so no type-tweak suggestion is emitted. I removed that special case (always pass the type hir id).
- compiler/rustc_hir_typeck/src/check.rs, `check_fn`: replaced the `if ty_span == Some(param.span) && tcx.is_closure_like(..) { None } else {..}` with `SizedArgumentType(ty.map(|ty| ty.hir_id))`. Re-expresses fix hunk `@@ -96,7 +96,19 @@ check_fn`.
- compiler/rustc_hir_typeck/src/gather_locals.rs, visit_pat: replaced the `ty_span == ident.span && is_closure_like` conditional with `SizedArgumentType(Some(hir_id))`. Re-expresses hunk `@@ -129,7 +129,17 @@ GatherLocalsVisitor`.
(The suggestions.rs hunk was a pure rename; not reproduced.)

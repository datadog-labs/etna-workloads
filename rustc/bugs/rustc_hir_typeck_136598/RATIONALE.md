# Adapted injection for Only suggest unit for unit fallback when spans dont come from macro expansion

Fix: https://github.com/rust-lang/rust/commit/cac63ffc0fe4d963f902311d5938e03a0a8437aa

# Rationale
All in compiler/rustc_hir_typeck/src/fallback.rs, `AnnotateUnitFallbackVisitor`. Removed the `can_be_used_for_suggestions()` guards that the fix added (reverse of fix hunks):
- `visit_infer` (@@ -651,6 +651,7 @@ `&& inf_span.can_be_used_for_suggestions()`)
- `visit_qpath` (@@ -662,7 +663,7 @@ / -674 hunk: `&& span.can_be_used_for_suggestions()`; param renamed back to `_span`)
- `visit_expr` (@@ -691,17 +694,21 @@: guards on the Path and MethodCall suggestions)
- `visit_local` (@@ -712,6 +719,7 @@: `&& local.span.can_be_used_for_suggestions()`)
So unit-fallback suggestions are again emitted for spans from macro expansions.

# Adapted injection for Revert some `span_bug`s to `span_delayed_bug`.

Fix: https://github.com/rust-lang/rust/commit/4f83e50f98f60d192e258b091d39d85c7d346310

# Rationale
Only the tuple-pattern hunk survives in 1.99.1 (the other three sites — ast_lowering "no def-id for fresh lifetime", generics_of host-effect, traits/mod.rs do_normalize_predicates region-resolution — were removed/rewritten).

## compiler/rustc_hir_typeck/src/expr_use_visitor.rs, `impl Delegate-cx for FnCtxt::report_bug`
Fix hunk: `@@ -582,7 +582,8 @@ ... MemCategorizationContext` in mem_categorization.rs:
`-  self.tcx().dcx().span_bug(span, "tuple pattern not applied to a tuple");`
`+  ...span_delayed_bug(...); Err(())`.
In 1.99.1 that code is `total_fields_in_tuple` -> `cx.report_bug(span, "tuple pattern not applied to a tuple")`; the FnCtxt `report_bug` returns a delayed bug. I changed it back to `span_bug!`, so the ICE returns (issue 121410).

# Adapted injection for Detect when method call on argument could be removed to fulfill failed trait bound

Fix: https://github.com/rust-lang/rust/commit/9b3fcf9ad44faa6362be348ef233bbc81d128308

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn suggest_remove_method_call-style logic in the function that handles `Node::Expr(expr) = tcx.hir_node(arg_hir_id)` (the arg-with-failed-bound suggestion helper).
I deleted the whole `if let hir::Expr { kind: MethodCall(_, rcvr, ..) } = expr && ... predicate_must_hold_modulo_regions(...)` block, including the `should_sugg` refinement and the `span_suggestion_verbose("consider removing this method call, as the receiver has type ... trivially holds")`.
This re-expresses the fix hunk `@@ -3961,6 +3961,24 @@` which added exactly that block (parent commit had no such suggestion).

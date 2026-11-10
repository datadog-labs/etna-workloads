# Adapted injection for Don't ICE in opaque_hidden_inferred_bound lint for RPITIT in trait with no default method body

Fix: https://github.com/rust-lang/rust/commit/6e982f59ab6919005ce9aa0301fba8d183415939

# Rationale
File: compiler/rustc_lint/src/opaque_hidden_inferred_bound.rs, fn `check_ty` (formerly `check_item`).
Removed the early return for RPITITs of body-less trait methods
(`if let FnReturn{parent: method_def_id,..} = opaque.origin && let Node::TraitItem(trait_item) = ... && !trait_item.defaultness.has_value() { return; }`).
Re-expresses fix hunk `@@ -72,6 +72,18 @@ impl LateLintPass for OpaqueHiddenInferredBound`, which added exactly that skip.

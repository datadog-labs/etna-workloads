# Adapted injection for Detect negative literal inferred to unsigned integer

Fix: https://github.com/rust-lang/rust/commit/18a36bccf5198dcc507d42e0daadcf2de4481741

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, in the E0277 reporting code.
Removed the call `suggested |= self.detect_negative_literal(&obligation, main_trait_predicate, &mut err);`.
This re-expresses fix hunk `@@ -280,6 +281,12 @@ ... try_conversion_context`, which added that call. Without it, the "consider specifying an integer type that can be negative" suggestion is never emitted.
The helper fn (fix hunk 3, `@@ -950,6 +957,38 @@`) remains in 1.99.1, now keyed on `ObligationCauseCode::UnOp`. I marked it `#[allow(dead_code)]` so it builds.

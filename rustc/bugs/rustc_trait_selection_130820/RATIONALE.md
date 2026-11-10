# Adapted injection for Fixed diagnostics for coroutines with () as input.

Fix: https://github.com/rust-lang/rust/commit/986e20d5bb5df4274b390b4148aab0058081a241

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, fn report_closure_arg_mismatch caller (the fn computing `found`/`expected` arg lists, ~line 3612).

Re-expresses fix hunk `@@ -2635,49 +2635,47 @@`, specifically the added re-check
`// If the coroutine take a single () as its argument ... if found.len() != expected.len() {`
after `get_fn_like_arguments`. Removed it, so report_arg_count_mismatch is always called when the
trait-derived lengths differ, giving "expected to take 1 argument, but it takes 1 argument" for coroutines taking `()`.

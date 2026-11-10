# Adapted injection for Normalize closure instance before eagerly monomorphizing it

Fix: https://github.com/rust-lang/rust/commit/2ada9ccb7d144075a6270aa94c20718be377148f

# Hunk: compiler/rustc_monomorphize/src/collector.rs, RootCollector::process_nested_body
Removed the `try_normalize_erasing_regions(TypingEnv::fully_monomorphized(), instance)` step (with its early `return` on error) before `create_fn_mono_item`. Re-expresses fix hunk `@@ -1509,6 +1509,13 @@ impl<'v> RootCollector` which added `let Ok(instance) = self.tcx.try_normalize_erasing_regions(...) else { return; };`. The closure instance is again eagerly collected unnormalized (upvars contain the RPIT opaque).

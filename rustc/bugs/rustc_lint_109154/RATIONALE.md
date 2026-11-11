# Adapted injection for Fix #109152, fix the scenario that we may can not get span of func

Fix: https://github.com/rust-lang/rust/commit/b3af5e2f8b58c96704d6a26a7a0e25b3b2bec6ad

# Hunks
compiler/rustc_lint/src/map_unit_fn.rs, `MapUnitFn::check_stmt`: `function_label: cx.tcx.span_of_impl(id).unwrap_or(arg.span)` changed back to `.span_of_impl(id).unwrap()`.
Re-expresses fix hunks `@@ -64,7 +65,10 @@` / `@@ -80,7 +84,10 @@` (`.unwrap_or(default_span)` replacing `.unwrap()`); in 1.99.1 the two branches are merged and default_span is `arg.span`. Result: ICE for `vec![42].iter().map(drop)` where span_of_impl returns Err.

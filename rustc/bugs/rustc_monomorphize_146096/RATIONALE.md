# Adapted injection for check normalization overflow in monomorphization

Fix: https://github.com/rust-lang/rust/commit/08f16a9c46cd33b21435cbf1da2abb8b001c7c4f

# Hunk: compiler/rustc_monomorphize/src/collector.rs, `collect_items_of_instance`
Removed the call `check_normalization_error(tcx, instance, body)?;` (and marked the now-unused helper `#[allow(dead_code)]`).
Re-expresses fix hunk `@@ -1259,11 +1306,15 @@ fn collect_items_of_instance` which added
`check_normalization_error(tcx, instance, body)?;` ("Plenty of code paths later assume that everything can be normalized").
Without it, normalization overflow during monomorphization is not detected up front, so later code ICEs / hits the old crashes instead of emitting the "reached the recursion limit while instantiating" error.

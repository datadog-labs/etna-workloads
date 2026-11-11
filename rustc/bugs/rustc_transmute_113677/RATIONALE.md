# Adapted injection for Safe Transmute: Fix ICE (due to UnevaluatedConst)

Fix: https://github.com/rust-lang/rust/commit/ef50e204f35ba2952f7ffd0e7560b136f1ace0aa

# compiler/rustc_transmute/src/lib.rs, `Assume::from_const`
`let cv = ct.try_to_value()?;` -> `let cv = ct.to_value();`
Re-expresses fix hunk `@@ -148,7 +149,17 @@ mod rustc` (`let fields = c.to_valtree().unwrap_branch();` replaced by a `try_to_valtree()` match returning a fallback for non-Value consts). In 1.99.1 the code is `try_to_value()?` (graceful); reverting to the panicking `to_value()` ICEs (bug!) on an unevaluated const. The consts.rs hunk (adding `try_to_valtree`) is already covered by existing `try_to_value`; no change needed.

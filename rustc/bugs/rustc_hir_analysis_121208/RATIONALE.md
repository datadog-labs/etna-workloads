# Adapted injection for Convert `bug`s back to `delayed_bug`s.

Fix: https://github.com/rust-lang/rust/commit/2903bbbc156fb9707b43038af6723844fd4ccf29

# Rationale
File: compiler/rustc_hir_analysis/src/check/always_applicable.rs, fn check_drop_xor_pin_drop (moved from dropck.rs).
Case `(None, None)` with no pin_ergonomics: `span_delayed_bug(..., "missing `Drop::drop`")` + return Err is changed back to a hard `span_bug`.
Re-expresses the fix's theme (hunk `@@ -67,10 +67,11 @@ pub fn check_drop_impl` in dropck.rs: `span_bug` -> `span_delayed_bug` + `Err(reported)`), in the 1.99.1 location of the Drop checks. The missing-drop-method.rs test (impl Drop with no `drop`) now ICEs instead of reporting E0046.

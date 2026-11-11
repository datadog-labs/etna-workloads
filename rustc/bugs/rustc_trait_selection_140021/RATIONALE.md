# Adapted injection for Don't ICE on pending obligations from deep normalization in a loop

Fix: https://github.com/rust-lang/rust/commit/47911eb677a29006d243a0b6bf17f26486191ead

# Rationale
File: compiler/rustc_trait_selection/src/traits/normalize.rs, `At::deeply_normalize` (old-solver branch).
Re-expresses the fix hunk `@@ -77,7 +77,15 @@` which added, in the error branch,
`let _ = fulfill_cx.collect_remaining_errors(self.infcx);` before `Err(errors)`.
On 1.99.1 the code is a `match` on `TraitErrors::HasErrors`; I removed the `collect_remaining_errors` call (and its comment), so pending obligations are left over and the next loop iteration hits the "deeply_normalize should not be called with pending obligations" span_bug.

# Adapted injection for Don't do AccessDepth::Drop for types with no drop impl

Fix: https://github.com/rust-lang/rust/commit/4a099b29cdb6a7841019406f0f2b5035a1fd9a08

# Rationale
File: compiler/rustc_borrowck/src/lib.rs, fn `check_backward_incompatible_drop`.
Re-expresses fix hunk `@@ -1166,10 +1166,18 @@ fn check_backward_incompatible_drop`: the fix chose
`AccessDepth::Shallow(None)` when `!place.ty.needs_drop(...)`; I restored the parent's unconditional
`let sd = AccessDepth::Drop;`. (The other hunks were only the place/place_span renaming, which already compiles unchanged.)

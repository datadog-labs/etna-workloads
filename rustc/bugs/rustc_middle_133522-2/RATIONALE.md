# Adapted injection for Don't suggest restricting bound with unstable traits on stable

Fix: https://github.com/rust-lang/rust/commit/68253e14ee3d0e81881bc908b07b5ba141daf226

# Rationale
File: compiler/rustc_middle/src/ty/diagnostics.rs, fn suggest_constraining_type_params (code was rewritten since the fix; the Cow/post-message hunks are already restructured).

1. Hunk `@@ -278,8 +277,21 @@` (`if stable || tcx.sess.is_nightly_build() {`): the gate is replaced with `if true`, so unstable traits are suggested on stable builds too (the pre-fix behaviour).
2. Hunk `@@ -464,28 +476,32 @@` (`let post = if unstable_suggestion { " but it is an `unstable` trait" }`): the "unstable " label stored in the grouped tuple is now always "", so suggestions no longer say the trait is unstable (pre-fix wording).

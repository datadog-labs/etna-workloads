# Adapted injection for Fix suggestion on `CallToDeprecatedSafeFnRequiresUnsafe` diagnostic

Fix: https://github.com/rust-lang/rust/commit/8aa0e905f4a1806a9406eb7c34e0c58157dc2856

# Hunk
compiler/rustc_mir_build/src/diagnostics.rs (errors.rs was renamed), `CallToDeprecatedSafeFnRequiresUnsafeSub` multipart_suggestion message.
Re-expresses fix hunk `@@ -22,7 +22,7 @@ pub(crate) struct CallToDeprecatedSafeFnRequiresUnsafe`: the fix replaced the hardcoded
"...guarantee that the environment access only happens in single-threaded code" with "...guarantee {$guarantee}". Buggy behaviour restored by hardcoding the text again.

# Adapted injection for unused-lifetimes: don't warn about lifetimes originating from expanded code

Fix: https://github.com/rust-lang/rust/commit/a3637032db5426a47d2ed6c91dcb4f65929bcf58

# Hunk: compiler/rustc_resolve/src/late/diagnostics.rs, late-resolution unused-lifetime check (`None =>` arm of the lifetime-use match)
Removed the guard `if deletion_span.is_some_and(|sp| !sp.in_derive_expansion())` so UNUSED_LIFETIMES is buffered even for lifetimes from derive-expanded code.
Re-expresses fix hunk `@@ -2244,19 +2244,23 @@` which added `lifetime_only_in_expanded_code = deletion_span.map(|sp| sp.in_derive_expansion()).unwrap_or(true); if !lifetime_only_in_expanded_code { buffer_lint... }`.

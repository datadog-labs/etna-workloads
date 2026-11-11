# Adapted injection for Don't suggest turning non-char-literal exprs of ty `char` into string literals

Fix: https://github.com/rust-lang/rust/commit/27cdc0df4e73b76466c72ae69ab6545f84089ad2

File: compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, fn that builds suggestions (arm `(ty::Ref(_, r, _), ty::Char) if r.is_str()`).
Removed the `span_to_snippet` check (`code.starts_with("'") && code.ends_with("'")`), so MeantStrLiteral is pushed unconditionally.
Re-expresses fix hunk `@@ -2064,10 +2064,15 @@` in rustc_infer error_reporting/mod.rs (file moved in 1.99.1).

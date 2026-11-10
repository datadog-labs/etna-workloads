# Adapted injection for Fix 2 variable binding issues in let_underscore

Fix: https://github.com/rust-lang/rust/commit/75df38e8165622e623fc24266ef4da49fd093933

# Hunks
1. compiler/rustc_lint/src/let_underscore.rs, `LetUnderscore::check_local`: removed the early return
   `if matches!(local.source, LocalSource::AsyncFn) { return; }`. Re-expresses fix hunk
   `@@ -108,6 +108,10 @@ ... check_local` (which added that AsyncFn early return). Bug: lint fires on async-fn desugared lets (#119696).
2. compiler/rustc_lint/src/diagnostics.rs, `NonBindingLetSub::add_to_diag`: `prefix` is always `""` instead of
   `"let "` for assign-desugar. Re-expresses lints.rs hunk `@@ -960,10 +961,11 @@` (`let prefix = if self.is_assign_desugar {"let "} else {""}`). Bug: suggestion for `_ = x` yields `_unused` without `let` (#119697).

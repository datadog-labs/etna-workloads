# Adapted injection for remove importing suggestions when there is a shadowed typo canddiate

Fix: https://github.com/rust-lang/rust/commit/2a229c96e8ca9cad46248555202619709fd3c2fe

# Rationale
File: compiler/rustc_resolve/src/late/diagnostics.rs, fn smart_resolve_report_errors.
Fix hunk `@@ -460,7 +460,7 @@` / `@@ -473,10 +473,12 @@`:
`let (found, mut candidates)` ... `if self.suggest_shadowed(...) { // if there is already a shadowed name, don'suggest candidates for importing  candidates.clear(); }`.
Re-injected: the result of suggest_shadowed no longer clears `candidates`, so the "consider importing this trait instead" suggestion is emitted again alongside the shadowed-name label (the pre-fix behaviour). `mut` dropped from the binding since it is no longer mutated. The other fix hunks (moving the label code into suggest_shadowed) are pure refactor and already equivalent.

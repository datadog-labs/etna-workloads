# Adapted injection for Do not ICE on expect(warnings).

Fix: https://github.com/rust-lang/rust/commit/6dfc4033be7c7d9f6551b2db093fd3bdbbc45cc2

All hunks in compiler/rustc_errors/src/lib.rs, re-adding what the fix removed:
- DiagCtxtInner struct: re-added field `stolen_fulfilled_expectations: bool` (fix hunk `@@ -502,14 +502,14 @@ struct DiagCtxtInner`, removal of the field).
- DiagCtxt reset destructuring: re-added `stolen_fulfilled_expectations: _` (hunk `@@ -724,7 +724,6 @@`).
- steal_fulfilled_expectation_ids: sets flag true (hunk `@@ -1078,7 +1077,6 @@`).
- DiagCtxtInner::new: initialises flag false (hunk `@@ -1388,7 +1386,6 @@`).
- emit_diagnostic `Expect | ForceWarning` arm: re-added `assert!(!self.stolen_fulfilled_expectations, ...)` (hunk `@@ -1492,10 +1489,6 @@`), so `#[expect(warnings)]` ICEs.

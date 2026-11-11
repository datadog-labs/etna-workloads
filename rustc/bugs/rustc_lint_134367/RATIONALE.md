# Adapted injection for allow+update `deref_into_dyn_supertrait`

Fix: https://github.com/rust-lang/rust/commit/491599569c081985d6cc3eb4ab55d692e380e938

# Rationale
File: compiler/rustc_lint/src/deref_into_dyn_supertrait.rs, `declare_lint!(DEREF_INTO_DYN_SUPERTRAIT)`.
Re-expresses the fix hunks:
- `@@ -1,6 +1,5 @@` (removed `use rustc_session::lint::FutureIncompatibilityReason;`): re-added the import (as `fcw` in 1.99.1).
- `@@ -9,12 +8,12 @@` / `@@ -44,15 +43,14 @@`: lint level `Allow` -> `Warn`, restored the `@future_incompatible = FutureIncompatibleInfo { reason: fcw!(FutureReleaseSemanticsChange #89460) }`, and the old description text/doc first lines.
Effect: lint is warn-by-default and future-incompat, so the tests' stderr gains the "this will change its meaning" notes.

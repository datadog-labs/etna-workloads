# Adapted injection for Provide borrow-instead-of-move suggestions for calls of fn-like items from other crates

Fix: https://github.com/rust-lang/rust/commit/2280d8ea0028bf163b1d9ac25514614823843140

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, fn report_use_of_moved_or_uninitialized (the call-argument move handling).

Added `&& def_id.is_local()` to the condition guarding `self.suggest_borrow_generic_arg(...)`.
Re-expresses fix hunk `@@ -497,10 +496,7 @@` / `@@ -522,10 +518,17 @@`, which replaced the old
`def_id.as_local()` + HIR `fn_sig` / `hir::TyKind::Path` gating (borrow suggestion only for local
callees) with an `arg_param` from `fn_sig` that works for any fn-like item, including other crates.
The old behavior: no "borrow the value to avoid moving it" suggestion for fn-like items from other crates.
(The applicability downgrade to MaybeIncorrect is already present in 1.99.1's helper and was left alone.)

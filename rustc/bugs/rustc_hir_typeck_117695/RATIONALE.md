# Adapted injection for Reorder type mismatch suggestions

Fix: https://github.com/rust-lang/rust/commit/1854776fa947e6f12dda66ec7858d9c00a11ac95

# Rationale

## 1. compiler/rustc_hir_typeck/src/demand.rs, `emit_type_mismatch_suggestions`
Fix hunk `@@ -43,6 +43,7 @@` added `|| self.suggest_missing_unwrap_expect(...)` before `suggest_remove_last_method_call`,
and `@@ -58,8 +59,7 @@` removed it from the end of the chain. Reversed: `suggest_missing_unwrap_expect` is moved back to
the end of the `||` chain (after `suggest_returning_value_after_loop`), so other suggestions win first.

## 2. compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, `suggest_remove_last_method_call`
Not in fix.diff. In 1.99.1 this function has an extra guard (method name must start with `to_`/`as_` or be `into`)
which was added after the fix and which stops it from firing on `checked_abs()`, hiding the reorder bug.
I removed the guard (restoring the 2023 behaviour where any zero-arg method call qualified) so the old
precedence bug is observable again. This is the one hunk that goes beyond the fix diff.

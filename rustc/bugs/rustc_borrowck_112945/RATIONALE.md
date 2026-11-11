# Adapted injection for Don't use method span on clone suggestion

Fix: https://github.com/rust-lang/rust/commit/3a3f4a21445d1175294552fa40446a3116103cef

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mod.rs, fn explain_captures (clone suggestion, `sugg` else-branch for non-deref places).

Re-expresses the fix hunk `@@ -1135,10 +1135,10 @@`:
`-  fn_call_span.shrink_to_lo(), ... "clone().".to_string()` / `+  move_span.shrink_to_hi(), ... ".clone()".to_string()`.
The suggestion again uses the method-call span (inserting `clone().` before the method name) instead of the moved expression's span (`.clone()` after it). The code was restructured in 1.99.1 into a `sugg` vec; only the non-deref branch was reverted.

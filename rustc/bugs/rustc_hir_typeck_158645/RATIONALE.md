# Adapted injection for Check arg errors then write splatted call info

Fix: https://github.com/rust-lang/rust/commit/0b6190fd46e817660a4fe118480a34c392e1a016

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, fn check_argument_types' tuple-arg helper (returns TupledArgCheckOutcome).
Moved the `if tuple_arguments.is_splatted() { self.write_splatted_call(...) }` block from the success-only `else` branch (after arg-count error checks) back to right before `formal_input_tys.splice(...)`, i.e. before the E0057 count check. This re-expresses both fix hunks (`@@ -702,19 +702,6 @@` removal and `@@ -803,6 +790,19 @@` addition) in reverse. A splatted call with wrong arg count then records splatted-call info even though an error is emitted, causing the ICE.

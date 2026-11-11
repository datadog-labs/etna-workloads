# Adapted injection for add check for typo in let chains

Fix: https://github.com/rust-lang/rust/commit/806b4436014fa3ab6a4c6876ccbe939ec24d927e

# Rationale
compiler/rustc_hir_typeck/src/op.rs, `check_overloaded_binop` (AssignOp arm): the fix's hunk `@@ -308,23 +308,32 @@` added
`if let Err(e) = errors::maybe_emit_plus_equals_diagnostic(&self, assign_op, lhs_expr) { (e, None) } else { ...E0368 generic... }`.
I replaced the condition with `if false { unreachable!() } else {`, so the special "`+=` cannot be used in a let chain" diagnostic is never emitted (pre-fix behaviour: generic E0368 only).
The helper (now in diagnostics.rs) is left in place but unused.

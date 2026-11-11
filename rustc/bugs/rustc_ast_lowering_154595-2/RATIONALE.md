# Adapted injection for Emit fatal on invalid const args with nested defs

Fix: https://github.com/rust-lang/rust/commit/58af51e2435f81f2a6a2bc99556a21e047421bed

# Rationale
File compiler/rustc_ast_lowering/src/lib.rs, `UnrepresentableConstArgError` (struct, `new`, `emit`, plus the one construction site ~line 2725).
In 1.99.1 the fix's `overly_complex_const` closure was refactored into `UnrepresentableConstArgError::emit`.
Fix hunk `@@ -2563,12 +2564,14 @@` added `if WillCreateDefIdsVisitor.visit_expr(expr).is_break() { struct_span_fatal } else { struct_span_err }`.
I reverted to the old behaviour: always `struct_span_err(...).emit()`, dropping the `will_create_def_ids` field/visitor check, so invalid const args containing nested defs (closures, items) no longer abort fatally and continue to later stages (issue 154539).
The other fix hunks (visibility of the visitor, `use Visitor`, reformatting in expr.rs) are refactors with no behavioural effect.

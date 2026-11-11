# Adapted injection for Improve shadowed private field diagnostics

Fix: https://github.com/rust-lang/rust/commit/62db1ebca3c1f40ef42bd62283e060f3c8b88192

In 1.99.1 the fix's helper already exists, but the call sites differ from the fix diff. I removed them.
- compiler/rustc_hir_typeck/src/op.rs, `check_overloaded_binop`: removed the four `note_field_shadowed_by_private_candidate` calls. They are the rhs call in the coercion closure, the lhs and rhs calls in the assign-op E0368 branch, and the lhs and rhs calls in the E0369 branch. The fix hunks are `@@ -249,6 +249,11 @@`, `@@ -331,6 +336,17 @@` and `@@ -391,6 +407,17 @@`.
- compiler/rustc_trait_selection/.../fulfillment_errors.rs: removed the `note_field_shadowed_by_private_candidate_in_cause` call before `try_to_add_help_message`. It is the 1.99.1 equivalent of the fix's `self.note_shadowed_private_fields_in_binop(&mut err, &obligation, ...)` call (hunk `@@ -559,6 +559,11 @@`).
Result: the note "there is a field `field` on `A` ... but it is private" is no longer emitted for binary operators.

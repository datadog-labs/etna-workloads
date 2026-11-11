# Adapted injection for More intuitive error when using self to instantiate tuple struct with private field

Fix: https://github.com/rust-lang/rust/commit/7af72e79b9a75475150fd9c5ef05d331f3f2a0ba

compiler/rustc_resolve/src/late/diagnostics.rs, smart_resolve_context_dependent_help (the `call_has_self_arg` branch):
re-expresses fix hunk `@@ -821,12 +822,18 @@` which replaced the unconditional
`err.span_suggestion(call_span, "try calling `{ident}` as a method", ...)` with a struct/private-ctor check
(`update_err_for_private_tuple_struct_fields` + note "constructor is not visible here due to private fields").
I restored the unconditional method-call suggestion, so `S(self)` with a private-field tuple struct gets the
misleading "try calling as a method" suggestion instead of the private-fields error. The other hunks are refactoring only.
